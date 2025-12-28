// TODO Implement this library.
import 'package:get/get.dart';
import 'package:i_carry/app/modules/manage_team/controller/manage_team_controller.dart';

class ManageTeamBinding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut<ManageTeamController>(() => ManageTeamController());
  }
}