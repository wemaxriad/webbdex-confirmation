import 'package:confirmation_agent_app/app/routes/app_routes.dart';
import 'package:confirmation_agent_app/app/utils/common_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant_colors.dart';
import '../controller/profile_controller.dart';

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
        return controller.isLoggedIn.value
            ? _loggedInView(controller)
            : _notLoggedInView();
      }),
    );
  }

  /// ---------------- Logged In UI ----------------
  Widget _loggedInView(ProfileController controller) {
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
                  padding: const EdgeInsetsDirectional.only(top: 20, end: 16.0, start: 16.0),
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
                        const Divider(height: 30, thickness: 0.5, color: Color(0xffDCDCDC)),

                        // --- Contact Details (Middle Part of the Card) ---
                        _buildContactRow(
                          icon: Icons.phone,
                          value: controller.phone.value,
                        ),
                        const SizedBox(height: 10),

                        _buildContactRow(
                          icon: Icons.email,
                          value: controller.email.value,
                        ),
                        const SizedBox(height: 10),

                        _buildContactRow(
                          icon: Icons.location_on,
                          value: controller.country.value,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // --- Menu List (Functional Section) ---
            _buildMenuItem(
              title: "My orders",
              icon: Icons.receipt_long,
              onTap: () {
                Get.toNamed(AppRoutes.ORDER);
              },
            ),
            _buildMenuItem(
              title: "Terms & Condition",
              icon: Icons.article_outlined,
              onTap: () {
                Get.toNamed(AppRoutes.TERMS_AND_CONDITIONS);
              },
            ),
            _buildMenuItem(
              title: "Privacy policy",
              icon: Icons.lock_outline,
              // Not the final item now, as Logout is next
              onTap: () {
                Get.toNamed(AppRoutes.PRIVACY_POLICY);
              },
            ),

            // --- LOGOUT BUTTON (New Section) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: primaryColor),
                title: const Text("Logout"),
                onTap: () {
                  // --- Logout Confirmation Dialog ---
                  Get.defaultDialog(
                    title: "Logout",
                    middleText: "Are you sure you want to log out?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    onConfirm: () {
                      controller.logout();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- NOT Logged In ----------------
  Widget _notLoggedInView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/notlogin.png', height: 160),
            const SizedBox(height: 12),
            const Text(
              "Not Logged In",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              "Your account information is not available",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            buttonPrimary(
              "Login",
              () {
                Get.toNamed(AppRoutes.SIGNIN);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Reusable Widgets ----------

  // Profile Header in the Card
  Widget _buildProfileHeader(ProfileController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() => CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(controller.profileImage.value),
            )),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.name.value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Member since ${controller.memberSince.value}",
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
        ),
        // --- EDIT ICON ---
        InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.EDIT_PROFILE);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.edit, color: primaryColor, size: 18),
          ),
        ),
      ],
    );
  }

  // Contact Info Row
  Widget _buildContactRow({required IconData icon, required String value}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[500], size: 20),
        const SizedBox(width: 15),
        Text(value, style: const TextStyle(fontSize: 14)),
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
