import 'package:get/get.dart';
import '../controller/order_call_controller.dart';
import '../controller/order_controller.dart';

class OrderCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(() => CallController());
  }
}
