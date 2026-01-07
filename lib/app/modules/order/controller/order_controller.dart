import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../model/order_model.dart';
import '../../../services/user-service.dart';
import '../model/orderModel.dart';
import '../service/order_service.dart';

class MyOrdersController extends GetxController {
  var allOrders = <Order>[].obs;
  // --- Change Status Dialog State ---
  var selectedStatus = 'Select Status'.obs;
  var statusNotes = ''.obs;
  var attachmentName = Rxn<String>(); // To hold the name of the attached file.
  var statusOptions = ['Select Status', 'Confirmed', 'Canceled'];

  final OrderService _service = OrderService();
  final UserService _userService = UserService();

  Rx<OrderData?> orderData = Rx<OrderData?>(null);
  RxList<OrderList> orderList = <OrderList>[].obs;
  RxList<OrderList> assignOrderList = <OrderList>[].obs;
  RxList<OrderList> confirmedOrderList = <OrderList>[].obs;

  RxBool isSubmitting = false.obs;
  RxBool isLoading = false.obs;
  int currentPage = 1;
  int lastPage = 1;
  RxBool isMoreLoading = false.obs;

  int assignOrderCurrentPage = 1;
  int assignOrderLastPage = 1;
  RxBool assignOrderIsMoreLoading = false.obs;

  int confirmedOrderCurrentPage = 1;
  int confirmedOrderLastPage = 1;
  RxBool confirmedOrderIsMoreLoading = false.obs;


  @override
  void onInit() {
    getOrderHistoryData(reset: true); // 🔥 load on start
    getAssignOrderHistoryData(reset: true); // 🔥 load on start
    getConfirmedOrderHistoryData(reset: true); // 🔥 load on start
    super.onInit();
  }

  Future<void> getOrderHistoryData({bool reset = false}) async {
    try {
      if (reset) {
        currentPage = 1;
        orderList.clear();
      }
      if (currentPage > lastPage) return;

      isLoading(reset);
      isMoreLoading(!reset);

      final data = await _service.getOrderHistoryData(page: currentPage);
      if (data != null) {
        lastPage =  data.lastPage??1;
        orderList.addAll(data.orderList ?? []);
        currentPage++;
      }
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }

  Future<void> getAssignOrderHistoryData({bool reset = false}) async {
    try {
      if (reset) {
        assignOrderCurrentPage = 1;
        assignOrderList.clear();
      }
      if (assignOrderCurrentPage > assignOrderLastPage) return;

      isLoading(reset);
      assignOrderIsMoreLoading(!reset);

      final data = await _service.getAssignOrderHistoryData(page: assignOrderCurrentPage);
      if (data != null) {
        assignOrderLastPage =  data.lastPage??1;
        assignOrderList.addAll(data.orderList ?? []);
        assignOrderCurrentPage++;
      }
    } finally {
      isLoading(false);
      assignOrderIsMoreLoading(false);
    }
  }

  Future<void> getConfirmedOrderHistoryData({bool reset = false}) async {
    try {
      if (reset) {
        confirmedOrderCurrentPage = 1;
        assignOrderList.clear();
      }
      if (confirmedOrderCurrentPage > confirmedOrderLastPage) return;

      isLoading(reset);
      confirmedOrderIsMoreLoading(!reset);

      final data = await _service.getConfirmedOrderHistoryData(page: confirmedOrderCurrentPage);
      if (data != null) {
        confirmedOrderLastPage =  data.lastPage??1;
        assignOrderList.addAll(data.orderList ?? []);
        confirmedOrderCurrentPage++;
      }
    } finally {
      isLoading(false);
      confirmedOrderIsMoreLoading(false);
    }
  }

  Future<void> refreshOrders() async {
    await getOrderHistoryData(reset: true);
  }


  // --- Status Change Logic ---
  void updateSelectedStatus(String? newStatus) {
    if (newStatus != null) {
      selectedStatus.value = newStatus;
    }
  }

  void updateStatusNotes(String notes) {
    statusNotes.value = notes;
  }

  // --- Attachment Logic ---
  void pickImageAttachment() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      attachmentName.value = image.name;
      Get.snackbar('Success', 'Image attached: ${image.name}');
    } else {
      Get.snackbar('Info', 'No image selected.');
    }
  }

  void pickAudioAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      attachmentName.value = result.files.single.name;
      Get.snackbar('Success', 'Audio attached: ${attachmentName.value}');
    } else {
      Get.snackbar('Info', 'No audio file selected.');
    }
  }

  void clearAttachment() {
    attachmentName.value = null;
  }

  void submitStatusChange(int orderId) {
    if (selectedStatus.value == 'Select Status') {
      Get.snackbar('Error', 'Please select a new status.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // debugPrint(
    //     'Submitting status change for Order $orderId: ${selectedStatus.value} with notes: ${statusNotes.value} and attachment: ${attachmentName.value}');

    final orderIndex = allOrders.indexWhere((order) => order.id == orderId);

    if (orderIndex != -1) {
      final updatedOrder = allOrders[orderIndex].copyWith(status: selectedStatus.value);
      allOrders[orderIndex] = updatedOrder;

      // Reset state
      selectedStatus.value = 'Select Status';
      statusNotes.value = '';
      clearAttachment();
      Get.back();
      Get.snackbar('Success', 'Order $orderId status updated.', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Order not found.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
