import 'package:cached_network_image/cached_network_image.dart';
import 'package:confirmation_agent_app/app/routes/app_routes.dart';
import 'package:confirmation_agent_app/app/utils/common_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helper/helper.dart';
import '../../../services/api-list.dart';
import '../../../utils/constant_colors.dart';
import '../../../globalController/global_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../controller/profile_controller.dart';
import 'confirmation_agent_documents_view.dart';
import 'shimmer/profile_shimmer_view.dart';
import 'webview_page.dart';

// Define a primary color based on the image (a bright red/pink)
//const Color kPrimaryColor = Color(0xffFF3B5D);

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5), // Light gray background

      body: Obx(() {
        if (controller.isLoading.value) {
          return const ProfileShimmerView();
        }

        return profileView(controller);
      }),
    );
  }

  /// ---------------- Logged In UI ----------------
  Widget profileView(ProfileController controller) {
    return RefreshIndicator(
      onRefresh: controller.refreshProfile,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. TOP HEADER SPACE
            // Pushes content down below the device's status bar
            //const SizedBox(height: 50),

            // 2. VISUAL HEADER (The red section)
            Stack(
              children: [
                // 3. MAIN PROFILE CARD (Positioned slightly into the red block)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 20,
                    end: 16.0,
                    start: 16.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // --- Profile Header (Top Part of the Card) ---
                        _buildProfileHeader(controller),
                        const Divider(
                          height: 30,
                          thickness: 0.5,
                          color: Color(0xffDCDCDC),
                        ),

                        // --- Contact Details (Middle Part of the Card) ---
                        _buildContactRow(
                          icon: Icons.phone,
                          value: controller.userDetails.value?.mobile ?? '',
                        ),
                        const SizedBox(height: 10),

                        _buildContactRow(
                          icon: Icons.email,
                          value: controller.userDetails.value?.email ?? "",
                        ),
                        const SizedBox(height: 10),

                        _buildContactRow(
                          icon: Icons.location_city,
                          value: controller.userDetails.value?.country ?? '',
                        ),
                        const SizedBox(height: 10),

                        _buildContactRow(
                          icon: Icons.location_on,
                          value: controller.userDetails.value?.address ?? '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (!(Get.isRegistered<DashboardController>() && Get.find<DashboardController>().isWebbyFirmUser))
              _buildMenuItem(
                title: Get.find<GlobalController>().t("My Documents"),
                icon: Icons.receipt_long,
                onTap: () {
                  Get.to(
                    () => const ConfirmationAgentDocumentsView(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),

            // --- Menu List (Functional Section) ---
            _buildMenuItem(
              title: Get.find<GlobalController>().t("Terms & Condition"),
              icon: Icons.article_outlined,
              onTap: () {
                Get.to(
                  () => WebViewPage(
                    title: "Terms & Condition",
                    url: ApiList.termsCondition.toString(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              title: Get.find<GlobalController>().t("Privacy policy"),
              icon: Icons.lock_outline,
              // Not the final item now, as Logout is next
              onTap: () {
                Get.to(
                  () => WebViewPage(
                    title: "Privacy Policy",
                    url: ApiList.privacyPolicy.toString(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              title: Get.find<GlobalController>().t("FAQ"),
              icon: Icons.question_mark_sharp,
              // Not the final item now, as Logout is next
              onTap: () {
                Get.to(
                  () => WebViewPage(
                    title: "FAQ",
                    url: ApiList.privacyFaq.toString(),
                  ),
                );
              },
            ),

            // --- DELETE ACCOUNT & LOGOUT ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: warningColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: warningColor,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        Get.find<GlobalController>().t("Delete Account"),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: warningColor,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        Get.find<GlobalController>().t(
                          "Permanently delete your account and data",
                        ),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          radius: 14,
                          title: Get.find<GlobalController>().t(
                            "Delete Account",
                          ),
                          titleStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                          middleText: Get.find<GlobalController>().t(
                            "This will permanently delete your account and associated data. This cannot be undone.",
                          ),
                          textConfirm: Get.find<GlobalController>().t("Delete"),
                          textCancel: Get.find<GlobalController>().t("Cancel"),
                          buttonColor: warningColor,
                          confirmTextColor: Colors.white,
                          cancelTextColor: greyPrimary,
                          onConfirm: () {
                            Get.back();
                            Get.find<AuthController>().userLogout();
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      title: Text(
                        Get.find<GlobalController>().t("Logout"),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        Get.defaultDialog(
                          radius: 14,
                          title: Get.find<GlobalController>().t("Logout"),
                          middleText: Get.find<GlobalController>().t(
                            "Are you sure you want to log out?",
                          ),
                          textConfirm: Get.find<GlobalController>().t("Yes"),
                          textCancel: Get.find<GlobalController>().t("No"),
                          buttonColor: primaryColor,
                          confirmTextColor: Colors.white,
                          cancelTextColor: greyPrimary,
                          onConfirm: () {
                            Get.back();
                            controller.logout();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Header in the Card
  Widget _buildProfileHeader(ProfileController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(
          () => CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: controller.userDetails.value?.image ?? '',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Icon(Icons.person, size: 30),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 30),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Get.find<GlobalController>().t(
                  controller.userDetails.value?.name ?? '',
                ),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${Get.find<GlobalController>().t("Member since")} ${formatMonthYear(controller.userDetails.value?.createdAt ?? '')}",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        // --- EDIT ICON ---
        // InkWell(
        //   onTap: () {
        //     Get.toNamed(AppRoutes.EDIT_PROFILE);
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.all(6),
        //     decoration: BoxDecoration(
        //       color: primaryColor.withOpacity(0.1),
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: const Icon(Icons.edit, color: primaryColor, size: 18),
        //   ),
        // ),
      ],
    );
  }

  // Contact Info Row
  Widget _buildContactRow({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[500], size: 20),
        const SizedBox(width: 15),
        Text(
          Get.find<GlobalController>().t(value),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  // General Menu Item
  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: Colors.grey[600]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
