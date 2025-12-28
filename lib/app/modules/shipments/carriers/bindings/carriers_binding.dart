import 'package:get/get.dart';

import '../controller/carriers_controller.dart';

class CarriersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarriersController>(() => CarriersController());
  }
}
