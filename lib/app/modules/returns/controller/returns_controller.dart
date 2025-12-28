import 'package:get/get.dart';

class ReturnController extends GetxController {
  var trackingId = ''.obs;
  var reason = ''.obs;
  var isLoading = false.obs;

  void submitReturn() async {
    if (trackingId.isEmpty || reason.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    isLoading(true);

    await Future.delayed(Duration(seconds: 2)); // API request simulation

    isLoading(false);

    Get.snackbar("Success", "Return request submitted!");
    Get.back(); // go back after submission
  }
}
