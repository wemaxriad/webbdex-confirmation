import 'package:get/get.dart';
import '../controller/terms_controller.dart';

class TermsBinding implements Bindings {
  @override
  void dependencies() {
    // Uses Get.lazyPut to instantiate the controller only when it is needed (i.e., when the view is opened)
    Get.lazyPut<TermsController>(() => TermsController());
  }
}