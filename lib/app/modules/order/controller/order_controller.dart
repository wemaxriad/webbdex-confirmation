import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/user-service.dart';
import '../../../utils/constant_colors.dart';
import '../model/orderDetailsModel.dart';
import '../model/orderModel.dart';
import '../service/order_service.dart';
import '../view/order_details_view.dart';

class MyOrdersController extends GetxController {
  // --- Change Status Dialog State ---
  var selectedStatus = 'Select Status'.obs;
  var assignSelectedStatus = 'Assign Order'.obs;
  var statusNotes = ''.obs;
  /// Attachment
  File? selectedAudioFile;
  File? selectedImageFile;
  var attachmentName = RxnString();
  var attachmentAudioName = RxnString();
  var statusOptions = ['Select Status', 'Confirmed', 'Canceled'];
  var assignStatusOptions = ['Assign Order'];

  final OrderService _service = OrderService();
  final UserService _userService = UserService();

  final pendingSearchCtrl = TextEditingController();
  final confirmedSearchCtrl = TextEditingController();
  final assignSearchCtrl = TextEditingController();

  Rx<OrderData?> orderData = Rx<OrderData?>(null);
  RxList<Order?> allOrders = <Order>[].obs;
  Rx<Order?> orderDetails = Rx<Order?>(null);
  RxList<OrderList> orderList = <OrderList>[].obs;
  RxList<OrderList> assignOrderList = <OrderList>[].obs;
  RxList<OrderList> confirmedOrderList = <OrderList>[].obs;

  RxBool isSubmitting = false.obs;
  RxBool isLoading = false.obs;
  int currentPage = 1;
  int lastPage = 1;
  RxBool isMoreLoading = false.obs;
  RxString currentCallSid = ''.obs;

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

      final data = await _service.getOrderHistoryData(page: currentPage,search: pendingSearchCtrl.text,);
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

      final data = await _service.getAssignOrderHistoryData(page: assignOrderCurrentPage,search: assignSearchCtrl.text,);
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
        confirmedOrderList.clear();
      }
      if (confirmedOrderCurrentPage > confirmedOrderLastPage) return;

      isLoading(reset);
      confirmedOrderIsMoreLoading(!reset);

      final data = await _service.getConfirmedOrderHistoryData(page: confirmedOrderCurrentPage,search: confirmedSearchCtrl.text,);
      if (data != null) {
        confirmedOrderLastPage =  data.lastPage??1;
        confirmedOrderList.addAll(data.orderList ?? []);
        confirmedOrderCurrentPage++;
      }
    } finally {
      isLoading(false);
      confirmedOrderIsMoreLoading(false);
    }
  }


  Future<void> getConfirmedOrderDetailsData(orderId,tenantId) async {
    try {
      Get.to(
            () => OrderDetailsView(),
        transition: Transition.downToUp,
      );
      isLoading(true);
      final data = await _service.getConfirmedOrderDetailsData(tenantId,orderId);
      if (data != null) {
        orderDetails.value = data;
      }
    }catch(e) {
      Get.back();
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshOrders() async {
    pendingSearchCtrl.clear();
    assignSearchCtrl.clear();
    confirmedSearchCtrl.clear();
    await getOrderHistoryData(reset: true);
    await getAssignOrderHistoryData(reset: true);
    await getConfirmedOrderHistoryData(reset: true);
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

  void showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Image Source',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.camera_alt, color: primaryColor),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                pickImageAttachment(ImageSource.camera);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library, color: primaryColor),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickImageAttachment(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }


  // --- Attachment Logic ---
  Future<void> pickImageAttachment(ImageSource source) async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImageFile = File(image.path);
      attachmentName.value = image.name;
    }
  }

  Future<void> pickAudioAttachment() async {
    final picker = FilePicker.platform;

    final result = await picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      selectedAudioFile = File(result.files.single.path!);
      attachmentAudioName.value = result.files.single.name;
    }
  }

  void clearAttachment() {
    selectedImageFile = null;
    attachmentName.value = null;
  }
  void clearAudioAttachment() {
    selectedAudioFile = null;
    attachmentAudioName.value = null;
  }

  Future<void> submitStatusChange(String orderId,tenantId,status) async {
    if(status != 'Assign Order') {
      if (selectedStatus.value == 'Select Status') return;
      status =  status == 'Confirmed' ? 'approved' : 'cancel';
    }

    if(status == 'Assign Order') {
      status = 'assign';
    }



    isLoading(true);
    final token = await _userService.getToken();
    final success = await _service.changeOrderStatus(
      token: token,
      orderId: orderId,
      tenantId: tenantId,
      status: status,
      note: statusNotes.value,
      callSid: currentCallSid.value,
      audioFile: selectedAudioFile,
      imageFile: selectedImageFile,
    );

    isLoading(false);

    if (success) {
      Get.back(); // close dialog
        Get.rawSnackbar(
          message: "Order status updated",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
        );
      clearAttachment();
      clearAudioAttachment();
      refreshOrders(); // refresh list
    }
  }


  void showChangeStatusConfirmDialog(OrderList order) {
    selectedStatus.value = 'Select Status';
    statusNotes.value = '';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Change Status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: primaryColor,
                        size: 30,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  "Select Status*",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Obx(
                      () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                        statusOptions.contains(
                          selectedStatus.value,
                        )
                            ? selectedStatus.value
                            : statusOptions.first,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        onChanged: (String? newValue) {
                          updateSelectedStatus(newValue);
                        },
                        items:  statusOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: value == 'Select Status'
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          );
                        })
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Note",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                TextField(
                  maxLines: 4,
                  onChanged: updateStatusNotes,
                  decoration: InputDecoration(
                    hintText: 'Add notes here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Get.isDialogOpen ?? false) {
                              Get.back();
                            }

                            // 2️⃣ Close call screen
                            if (Get.previousRoute.isNotEmpty) {
                              Get.back();
                            }
                          } ,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Obx(
                            () => SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: selectedStatus.value == 'Select Status'
                                ? null
                                : () async {
                              await submitStatusChange(
                                order.id.toString(),
                                order.tenantId.toString(),
                                selectedStatus.value,
                              );

                              // 1️⃣ Close popup
                              if (Get.isDialogOpen ?? false) {
                                Get.back();
                              }

                              // 2️⃣ Close call screen
                              if (Get.previousRoute.isNotEmpty) {
                                Get.back();
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Yes, Sure',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
