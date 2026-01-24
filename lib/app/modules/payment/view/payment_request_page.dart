import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../globalController/global_controller.dart';
import '../controller/payment_tabs_controller.dart';

class PaymentRequestPage extends GetView<PaymentTabsController> {
  const PaymentRequestPage({super.key});


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshPayments,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final data = controller.withdrawHistoryData.value;
          return  Column(
            children: [
              Row(
                children: [
                  _balanceCard(
          Get.find<GlobalController>().t("Available"),
                    data?.totalBalance ?? "0.00",
                    Colors.green,
                  ),
                  const SizedBox(width: 10),
                  _balanceCard(
          Get.find<GlobalController>().t("Pending"),
                    data?.totalWithdrawPending ?? "0.00",
                    Colors.orange,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              _inputField(
                label: Get.find<GlobalController>().t("Amount"),
                icon: Icons.payments,
                controller: controller.amountController,
              ),
              const SizedBox(height: 12),
              _inputField(
                label: Get.find<GlobalController>().t("Note (optional)"),
                icon: Icons.note,
                controller: controller.requestNoteController,
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submitWithdraw,
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      :  Text(Get.find<GlobalController>().t("Submit Withdrawal")),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Widget _balanceCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 8),
            Text(value,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

