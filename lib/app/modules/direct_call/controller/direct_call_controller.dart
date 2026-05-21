import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_voice/twilio_voice.dart';

import '../../../helper/helper.dart';
import '../../../services/api-list.dart';
import '../../../services/server.dart';
import '../../../services/user-service.dart';
import '../view/direct_call_screen_page.dart';

const String kDirectCallScreenRoute = '/webbyfirm-direct-call-screen';

class DirectCallController extends GetxController {
  final UserService _userService = UserService();
  final Server _server = Server();

  final RxString selectedCountryCode = '+1'.obs;
  final RxString phoneNumber = ''.obs;
  final RxString callStatus = 'Idle'.obs;
  final RxInt duration = 0.obs;
  final RxBool isMuted = false.obs;
  final RxBool isSpeaker = false.obs;
  final RxnDouble walletBalance = RxnDouble();
  final RxnDouble pricePerMinute = RxnDouble();
  final RxInt selectedTab = 0.obs;
  final RxBool isLogsLoading = false.obs;
  final RxBool isMoreLogsLoading = false.obs;
  final RxList<Map<String, dynamic>> directCallLogs = <Map<String, dynamic>>[].obs;

  StreamSubscription<CallEvent>? _callSubscription;
  Timer? _timer;
  int? _maxCallSeconds;
  int _logsCurrentPage = 1;
  int _logsLastPage = 1;

  final List<Map<String, String>> countryCodes = const [
    {'label': 'USA', 'code': '+1'},
    {'label': 'Egypt', 'code': '+20'},
    {'label': 'UAE', 'code': '+971'},
    {'label': 'Saudi', 'code': '+966'},
    {'label': 'Bangladesh', 'code': '+880'},
    {'label': 'India', 'code': '+91'},
    {'label': 'Pakistan', 'code': '+92'},
    {'label': 'Turkey', 'code': '+90'},
    {'label': 'UK', 'code': '+44'},
  ];

  @override
  void onInit() {
    super.onInit();
    _listenToEvents();
  }

  void _listenToEvents() {
    _callSubscription = TwilioVoice.instance.callEventsListener.listen((event) {
      callStatus.value = event.toString().split('.').last.capitalizeFirst ?? 'Call';

      if (event == CallEvent.connected) {
        _startTimer();
      }

      if (event == CallEvent.callEnded ||
          event == CallEvent.declined ||
          event == CallEvent.missedCall) {
        final endedByBalanceLimit =
            _maxCallSeconds != null && duration.value >= (_maxCallSeconds! - 5);
        _stopTimer();

        if (endedByBalanceLimit) {
          Get.snackbar(
            'Out of balance',
            'Recharge your tenant wallet to continue calling.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

        if (Get.currentRoute == kDirectCallScreenRoute) {
          Get.back();
        }

        getDirectCallLogs(reset: true);
      }
    });
  }

  void switchTab(int index) {
    selectedTab.value = index;
    if (index == 1 && directCallLogs.isEmpty) {
      getDirectCallLogs(reset: true);
    }
  }

  void setCountryCode(String? code) {
    if (code != null && code.trim().isNotEmpty) {
      selectedCountryCode.value = code;
    }
  }

  void addDigit(String digit) {
    if (phoneNumber.value.length >= 18) return;
    phoneNumber.value = '${phoneNumber.value}$digit';
  }

  void backspace() {
    if (phoneNumber.value.isEmpty) return;
    phoneNumber.value = phoneNumber.value.substring(0, phoneNumber.value.length - 1);
  }

  void clearNumber() {
    phoneNumber.value = '';
  }

  String get fullNumber {
    if (phoneNumber.value.trim().startsWith('+')) {
      return phoneNumber.value.trim();
    }

    return formatToE164(phoneNumber.value, selectedCountryCode.value);
  }

  Future<String?> getFcmToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  Future<bool> _checkPermissions() async {
    if (Platform.isIOS) {
      if (await TwilioVoice.instance.hasMicAccess()) return true;
      final allowed = await TwilioVoice.instance.requestMicAccess();
      if (allowed == true) return true;

      Get.snackbar(
        'Microphone needed',
        'Allow microphone access to place calls. Tap Settings to turn it on.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Settings'),
        ),
      );
      return false;
    }

    final mic = await Permission.microphone.request();
    if (!mic.isGranted) {
      Get.snackbar(
        'Microphone needed',
        mic.isPermanentlyDenied
            ? 'Microphone is off. Open Settings to allow it.'
            : 'Microphone permission is required to call.',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Settings'),
        ),
      );
      return false;
    }

    final phone = await Permission.phone.request();
    if (!phone.isGranted) {
      Get.snackbar(
        'Phone permission',
        'Phone permission is required to place calls.',
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Settings'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _setTwilioTokens({
    required String accessToken,
    String? androidFcmToken,
  }) async {
    if (Platform.isAndroid) {
      await TwilioVoice.instance.setTokens(
        accessToken: accessToken,
        deviceToken: androidFcmToken,
      );
      return;
    }

    if (!Platform.isIOS) {
      await TwilioVoice.instance.setTokens(
        accessToken: accessToken,
        deviceToken: androidFcmToken,
      );
      return;
    }

    const step = Duration(milliseconds: 400);
    final deadline = DateTime.now().add(const Duration(seconds: 25));
    Object? lastError;

    while (DateTime.now().isBefore(deadline)) {
      try {
        await TwilioVoice.instance
            .setTokens(accessToken: accessToken, deviceToken: null)
            .timeout(step);
        return;
      } on TimeoutException {
        await Future.delayed(step);
      } catch (e, st) {
        lastError = e;
        if (kDebugMode) {
          debugPrint('Direct Twilio setTokens retry: $e\n$st');
        }
        await Future.delayed(step);
      }
    }

    throw lastError ?? TimeoutException('VoIP push token not ready for Twilio');
  }

  Future<void> makeDirectCall() async {
    try {
      if (phoneNumber.value.trim().isEmpty) {
        Get.snackbar('Phone number required', 'Enter a number to call.');
        return;
      }

      if (!await _checkPermissions()) return;

      final userId = await _userService.getUserId();
      final token = await _userService.getToken();
      final fcmToken = Platform.isAndroid ? await getFcmToken() : null;

      if (token != null) {
        Server.initToken(token: token);
      }

      final response = await _server.postRequestWithToken(
        endPoint: ApiList.directCallToken,
        body: jsonEncode({'user_id': userId.toString()}),
      );

      if (response == null) {
        Get.snackbar('Call Error', 'Unable to start call');
        return;
      }

      if (response.statusCode != 200) {
        try {
          final body = jsonDecode(response.body);
          Get.snackbar(
            body['out_of_balance'] == true ? 'Out of balance' : 'Call Error',
            body['message']?.toString() ?? 'Unable to start call',
          );
        } catch (_) {
          Get.snackbar('Call Error', 'Unable to start call');
        }
        return;
      }

      final tokenBody = jsonDecode(response.body);
      final accessToken = tokenBody['token'];
      _maxCallSeconds = int.tryParse(tokenBody['max_call_seconds']?.toString() ?? '');
      walletBalance.value = double.tryParse(tokenBody['wallet_balance']?.toString() ?? '');
      pricePerMinute.value = double.tryParse(tokenBody['price_per_minute']?.toString() ?? '');

      Get.to<void>(
        () => const DirectCallScreenPage(),
        routeName: kDirectCallScreenRoute,
      );

      await _setTwilioTokens(
        accessToken: accessToken,
        androidFcmToken: fcmToken,
      );

      if (Platform.isAndroid) {
        final registered = await TwilioVoice.instance.registerPhoneAccount();
        if (registered != true) {
          Get.snackbar('Error', 'Phone account registration failed');
          return;
        }

        final enabled = await TwilioVoice.instance.isPhoneAccountEnabled();
        if (!enabled) {
          await TwilioVoice.instance.openPhoneAccountSettings();
          Get.snackbar(
            'Enable Phone Account',
            'Please enable the phone account to make calls',
          );
          return;
        }
      }

      await TwilioVoice.instance.call.place(
        to: fullNumber,
        from: '+16592007176',
        extraOptions: {
          'direct_call': '1',
          'user_id': userId.toString(),
          'country_code': selectedCountryCode.value,
          'call_note': '',
        },
      );
    } catch (e) {
      final message = e is TimeoutException && Platform.isIOS
          ? 'Wait a few seconds after opening the app (VoIP setup), then try again.'
          : e.toString();
      Get.snackbar('Call Error', message);
    }
  }

  Future<void> getDirectCallLogs({bool reset = false}) async {
    try {
      if (reset) {
        _logsCurrentPage = 1;
        _logsLastPage = 1;
        directCallLogs.clear();
      }

      if (_logsCurrentPage > _logsLastPage) return;

      isLogsLoading.value = reset;
      isMoreLogsLoading.value = !reset;

      final token = await _userService.getToken();
      if (token != null) {
        Server.initToken(token: token);
      }

      final response = await _server.getRequestToken(
        endPoint: '${ApiList.directCallLogs}?page=$_logsCurrentPage',
      );

      if (response == null || response.statusCode != 200) {
        return;
      }

      final jsonResponse = jsonDecode(response.body);
      final logs = jsonResponse['logs'];
      final List data = logs['data'] ?? [];
      directCallLogs.addAll(
        data.map((item) => Map<String, dynamic>.from(item as Map)),
      );
      _logsLastPage = int.tryParse(logs['last_page']?.toString() ?? '') ?? 1;
      _logsCurrentPage++;
    } finally {
      isLogsLoading.value = false;
      isMoreLogsLoading.value = false;
    }
  }

  String formatDuration(dynamic secondsValue) {
    final seconds = int.tryParse(secondsValue?.toString() ?? '') ?? 0;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  void endCall() {
    TwilioVoice.instance.call.hangUp();
  }

  void toggleMute() {
    isMuted.toggle();
    TwilioVoice.instance.call.toggleMute(isMuted.value);
  }

  void toggleSpeaker() {
    isSpeaker.toggle();
    TwilioVoice.instance.call.toggleSpeaker(isSpeaker.value);
  }

  void _startTimer() {
    _timer?.cancel();
    duration.value = 0;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => duration.value++,
    );
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String get formattedTime {
    final minutes = (duration.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onClose() {
    _callSubscription?.cancel();
    _timer?.cancel();
    super.onClose();
  }
}
