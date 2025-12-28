import 'package:get/get.dart';
import '../controller/add_warehouse_controller.dart';

class AddWarehouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddWarehouseController>(
      () => AddWarehouseController(),
    );
  }
}
