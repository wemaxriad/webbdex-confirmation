// TODO Implement this library.

import 'package:get/get.dart';
import '../controller/field_request_controller.dart';

class FailedRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FailedRequestsController>(() => FailedRequestsController());
  }
}
