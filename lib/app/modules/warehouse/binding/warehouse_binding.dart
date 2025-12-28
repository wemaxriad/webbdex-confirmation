import 'package:get/get.dart';

import '../controller/warehouse_controller.dart';

class WarehouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WarehouseController>(() => WarehouseController(), fenix: true);
  }
}
