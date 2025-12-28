import 'package:get/get.dart';

class RecipientsController extends GetxController {
  final title = "Recipients".obs;

  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> recipientList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;

  RxString searchQuery = "".obs;

  @override
  void onInit() {
    loadRecipients();

    debounce(
      searchQuery,
          (_) => applySearch(),
      time: const Duration(milliseconds: 300),
    );

    super.onInit();
  }

  void loadRecipients() async {
    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    recipientList.value = [
      {
        "id": "RC001",
        "name": "Abdul Karim",
        "phone": "01711-123456",
        "address": "Dhaka"
      },
      {
        "id": "RC002",
        "name": "Shamim Hossain",
        "phone": "01822-876543",
        "address": "Chattogram"
      },
      {
        "id": "RC003",
        "name": "Mizanur Rahman",
        "phone": "01933-564738",
        "address": "Sylhet"
      },
    ];

    filteredList.assignAll(recipientList);
    isLoading.value = false;
  }

  void applySearch() {
    String query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredList.assignAll(recipientList);
      return;
    }

    filteredList.assignAll(
      recipientList.where((item) {
        return item["name"].toLowerCase().contains(query) ||
            item["phone"].toLowerCase().contains(query) ||
            item["address"].toLowerCase().contains(query) ||
            item["id"].toLowerCase().contains(query);
      }).toList(),
    );
  }
}
