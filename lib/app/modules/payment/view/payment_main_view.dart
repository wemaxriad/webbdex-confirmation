import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_tabs_controller.dart';
import 'payment_request_page.dart';
import 'payment_history_page.dart';

class PaymentMainView extends StatelessWidget {
  const PaymentMainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentTabsController());

    return RefreshIndicator(
      onRefresh: controller.refreshPayments,
      child: Column(
        children: [
          // 🔥 Top TabBar (NO AppBar)
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tabItem(
                    title: "Payment Request",
                    isActive: controller.currentTab.value == 0,
                    onTap: () => controller.changeTab(0),
                  ),
                  _tabItem(
                    title: "Payment History",
                    isActive: controller.currentTab.value == 1,
                    onTap: () => controller.changeTab(1),
                  ),
                ],
              );
            }),
          ),

          // 🔥 PageView inside DashboardView
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              children: const [
                PaymentRequestPage(),
                PaymentHistoryPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          if (isActive)
            Container(
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            )
        ],
      ),
    );
  }
}
