import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_voice/twilio_voice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../helper/helper.dart';
import '../../../services/api-list.dart';
import '../../../services/user-service.dart';
import '../model/orderModel.dart';
import '../order_call_route.dart';
import '../view/order_call_screen_page.dart';
import 'order_controller.dart';

class CallController extends GetxController {
  final isMuted = false.obs;
  final isSpeaker = false.obs;
  final duration = 0.obs;
  final callStatus = "Idle".obs;
  final RxString currentCallSid = ''.obs;
  final UserService _userService = UserService();
  Rx<OrderList?> orderData = Rx<OrderList?>(null);
  StreamSubscription<CallEvent>? _callSubscription;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _listenToEvents();
  }

  void _listenToEvents() {
    _callSubscription = TwilioVoice.instance.callEventsListener.listen((event) {
      callStatus.value = event.toString().split('.').last.capitalizeFirst!;

      if (event == CallEvent.connected) {
        _startTimer();
      }

      if (event == CallEvent.callEnded ||
          event == CallEvent.declined ||
          event == CallEvent.missedCall) {
        _stopTimer();

        // Close call screen safely
        if (Get.isOverlaysOpen ?? false) {
          Get.back();
        }

        Future.delayed(const Duration(milliseconds: 300), () {
          try {
            if (Get.isRegistered<MyOrdersController>() &&
                orderData.value != null) {
              Get.find<MyOrdersController>().showChangeStatusConfirmDialog(
                orderData.value!,
              );
            }
          } catch (e) {
            print("Dialog Error: $e");
          }
        });
      }
    });
  }

  /// Initial Registration with Token
  Future<void> initTwilio(String accessToken, String? fcmToken) async {
    await _setTwilioTokens(
      accessToken: accessToken,
      androidFcmToken: Platform.isAndroid ? fcmToken : null,
    );
  }

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<bool> _checkPermissions() async {
    // iOS: use Twilio's native AVAudioSession APIs. `permission_handler`'s microphone
    // channel is a no-op / always-denied unless PERMISSION_MICROPHONE is set in Podfile.
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

  /// On iOS, `twilio_voice` only completes the method-channel future for `setTokens`
  /// after PushKit has delivered a VoIP device token. If `setTokens` runs before that,
  /// the native side returns without ever calling `result`, and this await would hang
  /// forever—so outgoing calls never start. We retry with short timeouts until the
  /// native handler can return (token is cached on the native side after PushKit fires).
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
          debugPrint('Twilio setTokens retry: $e\n$st');
        }
        await Future.delayed(step);
      }
    }

    throw lastError ?? TimeoutException('VoIP push token not ready for Twilio');
  }

  Future<void> registerPhoneAccountAndPrompt() async {
    // 1️⃣ Register Phone Account
    final registered = await TwilioVoice.instance.registerPhoneAccount();

    if (!registered!) {
      Get.snackbar("Error", "Failed to register phone account");
      return;
    }

    // 2️⃣ Check if phone account is enabled
    final enabled = await TwilioVoice.instance.isPhoneAccountEnabled();
    if (!enabled) {
      // Prompt user to enable it
      await TwilioVoice.instance.openPhoneAccountSettings();
      Get.snackbar(
        "Enable Phone Account",
        "Please enable the phone account in settings to make calls",
      );
      return;
    }

    print("✅ Phone account registered and enabled");
  }

  /// ✅ START CALL
  /// ✅ MAIN CALL FUNCTION
  Future<void> makeCall(OrderList order, String customerPhone) async {
    try {
      orderData.value = order;
      // 1️⃣ Permissions
      if (!await _checkPermissions()) return;
      Get.to<void>(
        () => const OrderCallScreenPage(),
        routeName: kOrderCallScreenRoute,
      );

      final userId = await _userService.getUserId();
      final fcmToken = Platform.isAndroid ? await getFcmToken() : null;

      // 2️⃣ Fetch Twilio token
      final response = await http.post(
        Uri.parse('${ApiList.orderCallToken}'),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode != 200) return;
      final accessToken = jsonDecode(response.body)['token'];

      // 3️⃣ Set tokens (iOS waits for PushKit VoIP credential when needed)
      await _setTwilioTokens(
        accessToken: accessToken,
        androidFcmToken: fcmToken,
      );

      // 4️⃣ Android only: register and verify Phone Account.
      if (Platform.isAndroid) {
        final registered = await TwilioVoice.instance.registerPhoneAccount();
        if (registered != true) {
          Get.snackbar("Error", "Phone account registration failed");
          return;
        }

        final enabled = await TwilioVoice.instance.isPhoneAccountEnabled();
        if (!enabled) {
          await TwilioVoice.instance.openPhoneAccountSettings();
          Get.snackbar(
            "Enable Phone Account",
            "Please enable the phone account to make calls",
          );
          return;
        }
      }
      // print(formatCountryPhoneNumber(customerPhone));
      // 6️⃣ Place call (ensure non-null 'to' and 'from')
      await TwilioVoice.instance.call.place(
        to: formatToE164(
          customerPhone,
          order.customerPhoneCode.toString(),
        ), // +201099321668
        // from: 'agent_$userId', // Twilio Client identity
        from: '+16592007176',
        extraOptions: {
          'order_id': order.id.toString(),
          'tenant_id': order.tenantId.toString(),
          'call_note': '',
        },
      );

      print("✅ Call placed successfully");
    } catch (e) {
      print("Call Error: $e");
      final String message = e is TimeoutException && Platform.isIOS
          ? 'Wait a few seconds after opening the app (VoIP setup), then try again.'
          : e.toString();
      Get.snackbar("Call Error", message);
    }
  }

  // Future<void> startCall({required String from, required String to}) async {
  //   var status = await Permission.microphone.request();
  //   if (!status.isGranted) return;
  //
  //   // In 0.3.2+2, methods are under the .call property
  //   await TwilioVoice.instance.call.place(
  //     from: from,
  //     to: to,
  //   );
  // }

  /// ✅ IN-CALL ACTIONS
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
      (t) => duration.value++,
    );
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String get formattedTime {
    final m = (duration.value ~/ 60).toString().padLeft(2, '0');
    final s = (duration.value % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void onClose() {
    _callSubscription?.cancel();
    _timer?.cancel();
    super.onClose();
  }
}
