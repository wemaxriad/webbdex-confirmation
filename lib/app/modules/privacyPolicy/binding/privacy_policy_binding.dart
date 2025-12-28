import 'package:get/get.dart';
import '../controller/privacy_controller.dart';

class PrivacyBinding implements Bindings {
  @override
  void dependencies() {
    // Instantiate the controller only when it is needed
    Get.lazyPut<PrivacyController>(() => PrivacyController());
  }
}