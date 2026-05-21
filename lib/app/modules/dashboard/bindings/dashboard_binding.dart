import 'package:confirmation_agent_app/app/modules/order/controller/order_controller.dart';
import 'package:get/get.dart';
import '../../direct_call/controller/direct_call_controller.dart';
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<MyOrdersController>(() => MyOrdersController());
    Get.lazyPut<DirectCallController>(() => DirectCallController());
  }
}
