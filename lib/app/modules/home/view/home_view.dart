// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';
//
// import '../controller/home_controller.dart';
//
// class HomeView extends GetView<HomeController> {
//   const HomeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Scaffold(
//         body: controller.pages[controller.selectedIndex.value],
//
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 blurRadius: 20,
//                 color: Colors.black.withOpacity(0.1),
//               )
//             ],
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
//
//           child: GNav(
//             backgroundColor: Colors.black,
//             color: Colors.black,
//             activeColor: Colors.white,
//             tabBackgroundColor: Colors.red,
//             gap: 6,
//
//             selectedIndex: controller.selectedIndex.value,
//             onTabChange: controller.changeTab,
//
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//
//             tabs: const [
//               GButton(icon: Icons.dashboard, text: "Dashboard"),
//               GButton(icon: Icons.list_alt, text: "Orders"),
//               GButton(icon: Icons.monetization_on, text: "Payment"),
//               GButton(icon: Icons.person, text: "Profile"),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }


