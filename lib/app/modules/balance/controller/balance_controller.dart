import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../../profile/service/profile_service.dart';
import '../model/walletHistoryModel.dart';

class BalanceController extends GetxController {
  final ProfiledService _service = ProfiledService();
  var isLoading = true.obs;

  // Financial data (using double and Rx for currency values)
  RxString totalAmount = '0.0'.obs;
  RxString withdrawableBalance = '0.0'.obs;
  RxString payableBalance = '0.0'.obs;

  @override
  void onInit() {
    fetchBalanceDetails();
    super.onInit();
  }

  Future<void> fetchBalanceDetails() async {
    try {
      isLoading(true);
      final WalletData? data = await _service.getBalance();

      if (data != null) {
        totalAmount.value  = data.totalBalance??'0.00';
        withdrawableBalance.value  = data.totalWithdrawPending??'0.00';
        payableBalance.value =   data.totalWithdrawPaid??'0.00';
      }

    } catch (e) {
      // ...
    } finally {
      isLoading(false);
    }
  }
}
