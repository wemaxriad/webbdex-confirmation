import 'package:get/get.dart';
import 'package:i_carry/app/modules/carrier_management/controller/add_carrier_controller.dart';

class AddCarrierBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCarrierController>(() => AddCarrierController());
  }
}
