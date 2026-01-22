import 'package:confirmation_agent_app/app/modules/payment/view/payment_main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
// Local imports
import '../../../globalController/global_controller.dart';
import '../../auth/controllers/auth_controller.dart';
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
                return  Text(
                  Get.find<GlobalController>().t("Dashboard"),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              case 1:
                return  Text(
                  Get.find<GlobalController>().t("My Order"),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              case 2:
                return  Text(
                  Get.find<GlobalController>().t("Payment"),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              case 3:
                return  Text(
                  Get.find<GlobalController>().t("Profile"),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              default:
                return  Text(
            Get.find<GlobalController>().t("Dashboard"),
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
              Obx(() => CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.zero,

                  icon: Text(
                    globalController.getLangIcon(globalController.selectedLang.value),
                    style: const TextStyle(fontSize: 18),
                  ),

                  onSelected: (slug) async {
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString('langKey', slug);
                    globalController.selectedLang.value = slug;
                    Get.updateLocale(Locale(slug));
                  },

                  itemBuilder: (BuildContext bc) {
                    return globalController.languagesList.map((lang) {
                      return PopupMenuItem<String>(
                        value: lang.slug,
                        child: Row(
                          children: [
                            Text(globalController.getLangIcon(lang.slug.toString())),
                            const SizedBox(width: 8),
                            Text(lang.name.toString()),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              )),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
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

                      Text(Get.find<GlobalController>().t('Welcome'),
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white)),
                       Text(Get.find<GlobalController>().t(controller.userDetails.value!.name.toString()),
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
                            children:  [
                              Icon(Icons.account_balance_wallet,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text(Get.find<GlobalController>().t("Check Balance"),
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
                        statCard(Get.find<GlobalController>().t("Assign Orders"),
                          Get.find<GlobalController>().t(controller.totalAssignedOrder.value.toString()), Colors.blue),
                        statCard(Get.find<GlobalController>().t("Confirmed Orders"),
                          Get.find<GlobalController>().t(controller.totalApprovedOrder.value.toString()), Colors.green),
                        statCard(Get.find<GlobalController>().t("Canceled Orders"),
                          Get.find<GlobalController>().t(controller.totalCancelOrder.value.toString()), Colors.red),
                        statCard(Get.find<GlobalController>().t("Pending Orders"),
                          Get.find<GlobalController>().t(controller.totalPending.value.toString()), Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(Get.find<GlobalController>().t("Recent Orders"),
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
                            title: Text("${Get.find<GlobalController>().t("Order")} #${Get.find<GlobalController>().t(order.id.toString())}"),
                            subtitle: Text(
                              "${Get.find<GlobalController>().t("Amount")}: ${Get.find<GlobalController>().t(order.totalAmount.toString())}",
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


  Widget statCard(String title, String value, Color color) {
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
      label: Text(Get.find<GlobalController>().t(status.toUpperCase()), style: const TextStyle(color: Colors.white)),
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
              tabs:  [
                GButton(icon: Icons.home, text:  Get.find<GlobalController>().t("Home")),
                GButton(icon: Icons.list_alt, text:  Get.find<GlobalController>().t("Order List")),
                GButton(
                    icon: Icons.monetization_on_outlined, text:  Get.find<GlobalController>().t("Withdraw")),
                GButton(icon: Icons.person, text:  Get.find<GlobalController>().t("Profile")),
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
                children:  [
                  Text(
                    '⏳ ${ Get.find<GlobalController>().t("Documents Under Review")}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    Get.find<GlobalController>().t("Your documents have been submitted and are currently under review. You will be able to access all features once your documents are approved."),
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
