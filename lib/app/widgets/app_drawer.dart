import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/language/controller/language_controller.dart';
import '../routes/app_pages.dart';
import '../utils/constants/colors.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final LanguageController langController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // header
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, bottom: 20),
            color: CustomColor.primaryColor,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.black12,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Nurul Islam",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 4),
                      Text("wedevs002@gmail.com",
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18),
                const SizedBox(width: 10),
              ],
            ),
          ),

          const Divider(height: 1),

          _drawerItem(Icons.dashboard_outlined, "Dashboard",
                  () => Get.offAllNamed(Routes.DASHBOARD)),
          _drawerItem(Icons.local_shipping_outlined, "Shipments",
                  () => Get.toNamed(Routes.SHIPMENTS)),
          _drawerItem(Icons.replay_outlined, "Returns",
                  () => Get.toNamed(Routes.RETURNS)),
          _drawerItem(Icons.error_outline, "Failed Requests",
                  () => Get.toNamed(Routes.FAILED_REQUESTS)),
          _drawerItem(Icons.warehouse_outlined, "Warehouses",
                  () => Get.toNamed(Routes.WAREHOUSES)),
          _drawerItem(Icons.group_outlined, "Recipients",
                  () => Get.toNamed(Routes.RECIPIENTS)),
          _drawerItem(Icons.category_outlined, "Products",
                  () => Get.toNamed(Routes.PRODUCTS)),
          _drawerItem(Icons.shopping_basket_outlined, "Orders",
                  () => Get.toNamed(Routes.ORDERS)),
          _drawerItem(Icons.credit_card_outlined, "Payments",
                  () => Get.toNamed(Routes.PAYMENTS)),
          _drawerItem(Icons.calculate_outlined, "Shipping Calculator",
                  () => Get.toNamed(Routes.SHIPPING_CALCULATOR)),
          _drawerItem(Icons.local_shipping, "Carriers",
                  () => Get.toNamed(Routes.CARRIERS)),
          _drawerItem(Icons.group_add_outlined, "Manage Team Member",
                  () => Get.toNamed(Routes.MANAGE_TEAM)),
          _drawerItem(Icons.business_outlined, "Company Profile",
                  () => Get.toNamed(Routes.COMPANY_PROFILE)),

          // --------------------------
          // 🔥 Inline Language Switch
          // --------------------------
          Obx(
                () => ExpansionTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text(
                "Language",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              children: [
                // English option
                ListTile(
                  title: const Text("English"),
                  trailing: langController.selectedLanguage.value == 0
                      ? const Icon(Icons.check_circle, color: CustomColor.primaryColor)
                      : const Icon(Icons.circle_outlined),
                  onTap: () => langController.changeLanguage(0),
                ),

                // Arabic option
                ListTile(
                  title: const Text("العربية"),
                  trailing: langController.selectedLanguage.value == 1
                      ? const Icon(Icons.check_circle, color: CustomColor.primaryColor)
                      : const Icon(Icons.circle_outlined),
                  onTap: () => langController.changeLanguage(1),
                ),
              ],
            ),
          ),

          _drawerItem(Icons.info_outline, "About iCARRY",
                  () => Get.toNamed(Routes.ABOUT)),
          _drawerItem(Icons.notifications_none, "Notification Settings",
                  () => Get.toNamed(Routes.NOTIFICATIONS)),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Logout",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 26, color: Colors.black87),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
