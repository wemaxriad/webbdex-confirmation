// TODO Implement this library.
import 'package:get/get.dart';
import '../controller/shipping_calculator_controller.dart';

class ShippingCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShippingCalculatorController>(() => ShippingCalculatorController());
  }
}
