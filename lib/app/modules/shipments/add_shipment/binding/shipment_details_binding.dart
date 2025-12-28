import 'package:get/get.dart';
import '../controller/shipment_details_controller.dart';

class ShipmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShipmentDetailsController>(() => ShipmentDetailsController());
  }
}
