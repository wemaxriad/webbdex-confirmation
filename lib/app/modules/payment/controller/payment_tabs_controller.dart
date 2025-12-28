import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentTabsController extends GetxController {
  var currentTab = 0.obs; // 0 for Payment Request, 1 for Payment History
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void changeTab(int index) {
    currentTab.value = index;
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentTab.value = index;
  }

  Future<void> refreshPayments() async {
    // Simulate a network call to refresh data
    await Future.delayed(const Duration(seconds: 2));
    // You might want to refresh data in your other controllers here
    Get.snackbar('Success', 'Payment data has been refreshed');
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
