import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_voice/twilio_voice.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../services/api-list.dart';

class CallController extends GetxController {
  final isMuted = false.obs;
  final isSpeaker = false.obs;
  final duration = 0.obs;
  final callStatus = "Idle".obs;

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

      switch (event) {
        case CallEvent.connected:
          _startTimer();
          break;
        case CallEvent.callEnded:
        case CallEvent.declined:
        case CallEvent.missedCall:
          _stopTimer();
          break;
        default:
          break;
      }
    });
  }

  /// Initial Registration with Token
  Future<void> initTwilio(String accessToken, String? fcmToken) async {
    // Android requires FCM token; iOS handles device token internally
    await TwilioVoice.instance.setTokens(
        accessToken: accessToken,
        deviceToken: fcmToken
    );
  }

  /// ✅ START CALL
  /// ✅ MAIN CALL FUNCTION
  Future<void> makeCall(String customerPhone, int userId) async {
    try {
      // 1. Check Permissions
      if (!(await Permission.microphone.request().isGranted)) return;

      // 2. Fetch Token from Laravel
      final response = await http.post(
        Uri.parse('${ApiList.orderCallToken}'),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];

        // 3. Register Client
        await TwilioVoice.instance.setTokens(accessToken: token);

        // 4. Place Call
        // This 'to' matches the $request->To in your Laravel handleOutgoing method
        await TwilioVoice.instance.call.place(
          to: customerPhone,
          from: 'agent_$userId',
        );
      } else {
        Get.snackbar("Error", "Failed to get access token");
      }
    } catch (e) {
      Get.snackbar("Call Error", e.toString());
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
  void endCall() => TwilioVoice.instance.call.hangUp();

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
    _timer = Timer.periodic(const Duration(seconds: 1), (t) => duration.value++);
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