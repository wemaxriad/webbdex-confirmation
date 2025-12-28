import 'package:get/get.dart';
import '../controller/add_recipient_controller.dart';

class AddRecipientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRecipientController>(
      () => AddRecipientController(),
    );
  }
}
