import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../model/order_model.dart';

class MyOrdersController extends GetxController {
  var allOrders = <Order>[].obs;

  // --- Change Status Dialog State ---
  var selectedStatus = 'Select Status'.obs;
  var statusNotes = ''.obs;
  var attachmentName = Rxn<String>(); // To hold the name of the attached file.

  var statusOptions = [
    'Select Status',
    'Confirmed',
    'Canceled',
  ];

  @override
  void onInit() {
    super.onInit();
    generateMockOrders();
  }

  Future<void> refreshOrders() async {
    // Simulate a network call to refresh data
    await Future.delayed(const Duration(seconds: 2));
    generateMockOrders();
    Get.snackbar('Success', 'Orders have been refreshed');
  }

  void generateMockOrders() {
    allOrders.value = List.generate(10, (index) {
      String status;
      String customerName;

      if (index == 0) {
        status = "Pending";
        customerName = "asm"; // Matches screenshot name
      } else {
        status = ["Confirmed", "Canceled", "Pending"][index % 3];
        customerName = "customer ${index}";
      }

      List<OrderItem> items = List.generate(
        3,
            (i) => OrderItem(
          name: "Product ${i + 1}",
          price: 20.0 + i * 10,
          qty: i + 1,
        ),
      ); 

      return Order(
        id: 2000 + index,
        status: status,
        items: items,
        customerName: customerName,
        pickupLocation: "barbar",
        deliveryLocation: "Budaiya",
      );
    });
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

    debugPrint(
        'Submitting status change for Order $orderId: ${selectedStatus.value} with notes: ${statusNotes.value} and attachment: ${attachmentName.value}');

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
