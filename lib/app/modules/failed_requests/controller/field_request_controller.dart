import 'package:get/get.dart';

class FailedRequestsController extends GetxController {
  final title = "Failed Requests".obs;

  RxBool isLoading = false.obs;

  // Original list (API result)
  RxList<Map<String, dynamic>> failedList = <Map<String, dynamic>>[].obs;

  // List after search filtering
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;

  RxString searchQuery = "".obs;

  @override
  void onInit() {
    fetchFailedRequests();
    debounce(searchQuery, (_) => applySearch(), time: const Duration(milliseconds: 300));
    super.onInit();
  }

  void fetchFailedRequests() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    failedList.value = [
      {
        "id": "FR001",
        "reason": "Invalid address",
        "date": "2025-01-17",
      },
      {
        "id": "FR002",
        "reason": "Recipient unavailable",
        "date": "2025-01-16",
      },
      {
        "id": "FR003",
        "reason": "Payment failed",
        "date": "2025-01-15",
      },
    ];

    filteredList.assignAll(failedList);
    isLoading.value = false;
  }

  /// Applying Search
  void applySearch() {
    String query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredList.assignAll(failedList);
      return;
    }

    filteredList.assignAll(failedList.where((item) {
      return item["id"].toLowerCase().contains(query) ||
          item["reason"].toLowerCase().contains(query);
    }).toList());
  }
}
