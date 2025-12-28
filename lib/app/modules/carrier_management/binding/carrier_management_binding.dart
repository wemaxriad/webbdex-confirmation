import 'package:get/get.dart';
import 'package:i_carry/app/modules/carrier_management/controller/carrier_management_controller.dart';

class CarrierManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarrierManagementController>(() => CarrierManagementController());
  }
}
