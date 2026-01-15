import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_voice/twilio_voice.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


import '../../../helper/helper.dart';
import '../../../services/api-list.dart';
import '../../../services/user-service.dart';
import '../model/orderModel.dart';
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
    _callSubscription =
        TwilioVoice.instance.callEventsListener.listen((event) {

          callStatus.value =
          event.toString().split('.').last.capitalizeFirst!;

          if (event == CallEvent.connected) {
            _startTimer();

          }


          if (event == CallEvent.callEnded ||
              event == CallEvent.declined ||
              event == CallEvent.missedCall) {

            _stopTimer();

            // ✅ Close call screen FIRST
            if (Get.isOverlaysOpen) {
              Get.back();
            }

            // ✅ THEN show confirmation popup
            Future.delayed(const Duration(milliseconds: 300), () {
              Get.find<MyOrdersController>()
                  .showChangeStatusConfirmDialog(orderData.value!);
            });
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

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<bool> _checkPermissions() async {
    final mic = await Permission.microphone.request();
    final phone = await Permission.phone.request();
    final readNumbers = await Permission.phone.request(); // or READ_PHONE_NUMBERS if available

    return mic.isGranted && phone.isGranted && readNumbers.isGranted;
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
  Future<void> makeCall(OrderList order,String customerPhone) async {
    try {
      orderData.value = order;
      // 1️⃣ Permissions
      if (!await _checkPermissions()) return;

      final userId = await _userService.getUserId();
      final fcmToken = await getFcmToken();

      // 2️⃣ Fetch Twilio token
      final response = await http.post(
        Uri.parse('${ApiList.orderCallToken}'),
        body: {'user_id': userId.toString()},
      );


      if (response.statusCode != 200) return;
      final accessToken = jsonDecode(response.body)['token'];

      // 3️⃣ Set tokens
      await TwilioVoice.instance.setTokens(
        accessToken: accessToken,
        deviceToken: fcmToken,
      );

      // 4️⃣ Register Phone Account & wait
      final registered = await TwilioVoice.instance.registerPhoneAccount();
      if (!registered!) {
        Get.snackbar("Error", "Phone account registration failed");
        return;
      }

      // 5️⃣ Ensure phone account is enabled
      final enabled = await TwilioVoice.instance.isPhoneAccountEnabled();
      if (!enabled) {
        await TwilioVoice.instance.openPhoneAccountSettings();
        Get.snackbar(
          "Enable Phone Account",
          "Please enable the phone account to make calls",
        );
        return;
      }
      // print(formatCountryPhoneNumber(customerPhone));
      // 6️⃣ Place call (ensure non-null 'to' and 'from')
      await TwilioVoice.instance.call.place(
        to: formatCountryPhoneNumber(customerPhone), // +201099321668
        from: 'agent_$userId', // Twilio Client identity
        extraOptions: {'order_id':order.id.toString(),'tenant_id':order.tenantId.toString(),'call_note':''},
      );

      print("✅ Call placed successfully");
    } catch (e) {
      print("Call Error: $e");
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