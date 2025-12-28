import 'package:confirmation_agent_app/app/modules/profile/controller/profile_controller.dart';
import 'package:get/get.dart';


class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
