import 'package:get/get.dart';
import 'package:i_carry/app/modules/dashboard/controller/dashboard_controller.dart';

class DashboardBinding extends Bindings{

  @override
  void dependencies() {
    // The LanguageController is now provided globally in main.dart.
    // This binding only needs to register the DashboardController.
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}