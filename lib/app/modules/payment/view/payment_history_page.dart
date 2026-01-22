import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../globalController/global_controller.dart';
import '../controller/payment_tabs_controller.dart';
import '../model/withdrawRequestModel.dart';

class PaymentHistoryPage extends GetView<PaymentTabsController> {
  const PaymentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshPayments,
      child: Obx(() {
        if (controller.isLoading.value &&
            controller.withdrawRequests.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.withdrawRequests.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children:  [
              SizedBox(height: 300),
              Center(child: Text(Get.find<GlobalController>().t("No withdrawal history"))),
            ],
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll.metrics.pixels ==
                scroll.metrics.maxScrollExtent &&
                !controller.isMoreLoading.value) {
              controller.getPaymentHistoryData();
            }
            return false;
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: controller.withdrawRequests.length +
                (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.withdrawRequests.length) {
                return const Padding(
                  padding: EdgeInsets.all(12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = controller.withdrawRequests[index];
              return _withdrawCard(item);
            },
          ),
        );
      }),
    );
  }

  Widget _withdrawCard(WithdrawRequests item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${Get.find<GlobalController>().t("TXN")}: ${Get.find<GlobalController>().t(item.transactionId??'-')}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("${Get.find<GlobalController>().t("Amount")}: ${Get.find<GlobalController>().t(item.amount.toString())}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text("${Get.find<GlobalController>().t("Status")}: ${Get.find<GlobalController>().t(item.statusName.toString())}"),
          const SizedBox(height: 6),
          Text("${Get.find<GlobalController>().t("Requested")}: ${Get.find<GlobalController>().t(item.createdAt.toString())}"),
          Text("${Get.find<GlobalController>().t("Paid")}: ${item.paidAt ?? '-'}"),
        ],
      ),
    );
  }
}



