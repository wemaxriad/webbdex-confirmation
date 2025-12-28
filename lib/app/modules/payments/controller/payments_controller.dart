import 'package:get/get.dart';

class PaymentsController extends GetxController {
  final title = "Payments".obs;

  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> paymentList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchPayments();
    super.onInit();
  }

  void fetchPayments() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    paymentList.value = [
      {
        "id": 1001,
        "amount": 2500,
        "status": "Paid",
        "date": "2025-01-18",
      },
      {
        "id": 1002,
        "amount": 1800,
        "status": "Paid",
        "date": "2025-01-17",
      },
      {
        "id": 1003,
        "amount": 3200,
        "status": "Pending",
        "date": "2025-01-16",
      },
    ];

    isLoading.value = false;
  }
}
