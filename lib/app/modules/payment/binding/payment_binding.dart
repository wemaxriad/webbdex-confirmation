import 'package:confirmation_agent_app/app/modules/payment/controller/payment_tabs_controller.dart';
import 'package:get/get.dart';


class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentTabsController>(() => PaymentTabsController());
  }
}
