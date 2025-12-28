import 'package:confirmation_agent_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:confirmation_agent_app/app/modules/profile/controller/edit_profile_controller.dart';
import 'package:get/get.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
    Get.lazyPut(() => AuthController());
  }
}
