import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class BalanceController extends GetxController {
  var isLoading = true.obs;

  // Financial data (using double and Rx for currency values)
  var totalOrderAmount = 0.0.obs;
  var withdrawableBalance = 0.0.obs;
  var payableBalance = 0.0.obs;

  @override
  void onInit() {
    fetchBalanceDetails();
    super.onInit();
  }

  Future<void> fetchBalanceDetails() async {
    try {
      isLoading(true);
      // TODO: Replace with your actual API call to fetch balance data
      await Future.delayed(const Duration(seconds: 1));

      // --- Mock Data Adjusted to Match Your Image ---
      totalOrderAmount.value = 32.00;
      withdrawableBalance.value = 32.00;
      payableBalance.value = 390.00;

    } catch (e) {
      // ...
    } finally {
      isLoading(false);
    }
  }
}
