// TODO Implement this library.
import 'package:get/get.dart';
import '../controller/returns_controller.dart';

class ReturnsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReturnController>(() => ReturnController());
  }
}
