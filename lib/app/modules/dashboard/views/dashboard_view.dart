import 'package:confirmation_agent_app/app/modules/payment/view/payment_main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
// Local imports
import '../../../globalController/global_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../controller/dashboard_controller.dart';
import '../../balance/view/balance_view.dart';
import '../../balance/controller/balance_controller.dart';
// Important: Global Controller for Custom AppBar
import '../../profile/view/profile_view.dart'; // Ensure ProfileView is imported
// ... (Other imports)
import '../../order/view/order_list_view.dart';
import 'documentStatusCard.dart';
import 'shimmer/dashboard_shimmer_view.dart'; // Import the new file

class DashboardView extends GetView<DashboardController> {
   DashboardView({super.key});

  static const Color kMainColor = Color(0xffFF3B30);
  // Red color from your theme
  static const Color textWhiteColor = Colors.white;
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: _buildResponsiveAppBar(context),
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return dashboardTab(controller);
          case 1:
            return const OrderListView();
          case 2:
            return const PaymentMainView();
          case 3:
            return const ProfileView();
          default:
            return dashboardTab(controller);
        }
      }),
      bottomNavigationBar: _buildBottomNav(),
    );
  }



  // --- Helper to build App Bar based on index ---
  PreferredSizeWidget _buildResponsiveAppBar(BuildContext context) {
    final globalController = Get.isRegistered<GlobalController>()
        ? Get.find<GlobalController>()
        : Get.put(GlobalController());
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      titleSpacing: 0,
      backgroundColor: kMainColor,
      elevation: 0.0,

      // --- Title Section (Business Name) ---
      title: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: ListTile(
          horizontalTitleGap: 0,
          contentPadding: const EdgeInsetsDirectional.only(end: 10.0),
          title: Obx(() {
            switch (controller.currentIndex.value) {
              case 0:
                return const Text(
                  "Dashboard",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              case 1:
                return const Text(
                  "My Order",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              case 2:
                return const Text(
                  "Payment",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              case 3:
                return const Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              default:
                return const Text(
                  "Dashboard",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
            }
          }),
        ),
      ),

      // --- Actions Section ---
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.language, color: kMainColor, size: 22),
                  onSelected: (newValue) {
                    Get.updateLocale(Locale(newValue));
                    Get.snackbar(
                      "Language",
                      newValue == 'ar' ? "تم تغيير اللغة" : "Language switched",
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  itemBuilder: (BuildContext bc) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'en',
                        child: Text("English"),
                      ),
                      const PopupMenuItem<String>(
                        value: 'ar',
                        child: Text("عربي"),
                      ),
                    ];
                  },
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.snackbar(
                      "Navigation",
                      "Navigating to Notification List",
                      snackPosition: SnackPosition.TOP,
                    );
                  },
                  icon: const Icon(Icons.notifications, color: kMainColor, size: 22),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  controller.currentIndex.value = 3;
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Obx(
                          () => Image.network(
                        globalController.userImage.value,
                        height: 32.0,
                        width: 32.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, color: kMainColor, size: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// ... (Keep dashboardTab and statCard methods here)
  Widget dashboardTab(DashboardController controller) {
    return RefreshIndicator(
      onRefresh: controller.refreshDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const DashboardShimmerView();
          }
          if(controller.userDetails.value?.confirmationAgentDetail?.status != 3) {
            var status = controller.userDetails.value?.confirmationAgentDetail?.status??1;
            return DocumentStatusCard(
              isSubmitted: status == 1 ?false:status == 1 ? true:true,
              status: status,
            );
          }

          /// 🔹 YOUR ORIGINAL UI (unchanged)
          return
            Column(
            children: [
              // ---------- HEADER ----------
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                      end: 20, start: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('welcome'.tr,
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white)),
                       Text("${controller.userDetails.value!.name}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(() => const BalanceView(),
                            binding: BindingsBuilder(() {
                              Get.put(BalanceController());
                            }),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.account_balance_wallet,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text("Check Balance",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios,
                                  size: 18, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------- BODY ----------
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3 / 2,
                      children: [
                        statCard("Assign Orders",
                            controller.totalAssignedOrder.value, Colors.blue),
                        statCard("Confirmed Orders",
                            controller.totalApprovedOrder.value, Colors.green),
                        statCard("Canceled Orders",
                            controller.totalCancelOrder.value, Colors.red),
                        statCard("Pending Orders",
                            controller.totalPending.value, Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text("Recent Orders",
                        style: Theme.of(Get.context!).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                        itemCount: controller.lastOrders.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (_, index) {
                          final order = controller.lastOrders[index];
                          return ListTile(
                            leading:
                            CircleAvatar(child: Text(order.id.toString())),
                            title: Text("Order #${order.id}"),
                            subtitle: Text(
                              "Amount: ${order.totalAmount}",
                            ),
                            trailing: orderStatusChip(order.confirmationStatus.toString()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }


  Widget statCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$value",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderStatusChip(String status) {
    Color bgColor;
    switch (status) {
      case "approved":
        bgColor = Colors.green.shade300;
        break;
      case "cancel":
        bgColor = Colors.red.shade300;
        break;
      case "assign":
        bgColor = Colors.orange.shade300;
        break;
        case "de-assign":
        bgColor = Colors.orange.shade300;
        break;
      default:
        bgColor = Colors.grey.shade300;
    }

    return Chip(
      label: Text(status.toUpperCase(), style: const TextStyle(color: Colors.white)),
      backgroundColor: bgColor,
    );
  }

  Widget _buildBottomNav() {
    return Obx(
      () => (controller.userDetails.value?.confirmationAgentDetail?.status ?? 1) != 3
          ? SizedBox()
          :
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: Colors.black.withOpacity(0.08),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              selectedIndex: controller.currentIndex.value,
              onTabChange: (index) {
                controller.currentIndex.value = index;
              },
              gap: 8,
              padding: const EdgeInsets.all(14),
              backgroundColor: Colors.white,
              color: Colors.grey[700],
              activeColor: Colors.white,
              tabBackgroundColor: DashboardView.kMainColor, // Use the static color
              tabBorderRadius: 30,
              tabs: const [
                GButton(icon: Icons.home, text: "Home"),
                GButton(icon: Icons.list_alt, text: "Order List"),
                GButton(
                    icon: Icons.monetization_on_outlined, text: "Withdraw"),
                GButton(icon: Icons.person, text: "Profile"),
              ],
            ),
          ),
        ),
      ),
    );
  }


}


class ReviewStatusCard extends StatelessWidget {
  const ReviewStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.hourglass_top,
                color: Colors.orange,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '⏳ Documents Under Review',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your documents have been submitted and are currently under review. '
                        'You will be able to access all features once your documents are approved.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }}
