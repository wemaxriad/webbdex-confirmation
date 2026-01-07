import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/user-service.dart';
import '../../../utils/constant_colors.dart';
import '../model/withdrawRequestModel.dart';
import '../service/payment_service.dart';

class PaymentTabsController extends GetxController {
  var currentTab = 0.obs;
  late PageController pageController;

  final PaymentService _service = PaymentService();
  final UserService _userService = UserService();

  Rx<WithdrawHistoryData?> withdrawHistoryData = Rx<WithdrawHistoryData?>(null);
  RxList<WithdrawRequests> withdrawRequests = <WithdrawRequests>[].obs;

  RxBool isSubmitting = false.obs;
  RxBool isLoading = false.obs;
  int currentPage = 1;
  int lastPage = 1;
  RxBool isMoreLoading = false.obs;

  final amountController = TextEditingController();
  final requestNoteController = TextEditingController();

  @override
  void onInit() {
    pageController = PageController();
    getPaymentHistoryData(reset: true); // 🔥 load on start
    super.onInit();
  }

  void changeTab(int index) {
    currentTab.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentTab.value = index;
  }

  /// 🔥 Load history + balance
  Future<void> getPaymentHistoryData({bool reset = false}) async {
    try {
      if (reset) {
        currentPage = 1;
        withdrawRequests.clear();
      }
      if (currentPage > lastPage) return;

      isLoading(reset);
      isMoreLoading(!reset);

      final data = await _service.getPaymentHistoryData(page: currentPage);
      if (data != null) {
        withdrawHistoryData.value = data;
        lastPage =  data.lastPage??1;
        withdrawRequests.addAll(data.withdrawRequests ?? []);
        currentPage++;
      }
    } finally {
      isLoading(false);
      isMoreLoading(false);
    }
  }

  /// 🔥 Submit withdraw
  Future<void> submitWithdraw() async {
    if (amountController.text.isEmpty) {
      Get.snackbar('Required', 'Amount is required');
      return;
    }

    isSubmitting(true);
    final token = await _userService.getToken();

    final success = await _service.storeWithdraw(
      token: token,
      amount: amountController.text,
      note: requestNoteController.text,
    );

    if (success) {
      amountController.clear();
      requestNoteController.clear();
      await getPaymentHistoryData();
      Get.snackbar(
        'Success',
        'Withdraw request submitted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    }else {
      Get.snackbar(
        'Withdraw Request',
        'Withdraw request submitted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

    isSubmitting(false);
  }

  Future<void> refreshPayments() async {
    await getPaymentHistoryData(reset: true);
  }

  @override
  void onClose() {
    pageController.dispose();
    amountController.dispose();
    requestNoteController.dispose();
    super.onClose();
  }
}

