// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/balance_controller.dart';
//
// class BalanceView extends GetView<BalanceController> {
//   const BalanceView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Controller is initialized here if no binding is used.
//     final controller = Get.put(BalanceController());
//
//     return Scaffold(
//       backgroundColor: const Color(0xffF5F5F5),
//       appBar: AppBar(
//         // Assuming your main AppBar style is red
//         backgroundColor: const Color(0xffFF3B30),
//         foregroundColor: Colors.white,
//         title: const Text("Balance Details", style: TextStyle(fontWeight: FontWeight.bold)),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.isTrue) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. Total Order Amount (Primary Card)
//               _buildBalanceCard(
//                 title: "Total Order Amount",
//                 amount: controller.totalOrderAmount.value,
//                 color: const Color(0xffFF3B30), // Red/Primary Color
//                 icon: Icons.receipt_long,
//               ),
//
//               const SizedBox(height: 16),
//
//               // 2. Withdrawable Balance Card
//               _buildBalanceCard(
//                 title: "Withdrawable Balance",
//                 amount: controller.withdrawableBalance.value,
//                 color: const Color(0xff39C367), // Green
//                 icon: Icons.account_balance_wallet,
//                 buttonText: "Withdraw Now",
//                 onPressed: () {
//                   // TODO: Implement navigation/dialog for withdrawal
//                   Get.snackbar("Action", "Withdrawal initiated for BD ${controller.withdrawableBalance.value.toStringAsFixed(3)}", snackPosition: SnackPosition.BOTTOM);
//                 },
//               ),
//
//               const SizedBox(height: 16),
//
//               // 3. Payable Balance Card
//               _buildBalanceCard(
//                 title: "Payable Balance",
//                 amount: controller.payableBalance.value,
//                 color: Colors.blueAccent, // Blue
//                 icon: Icons.payment,
//               ),
//
//               const SizedBox(height: 30),
//
//               const Text(
//                 "Recent Transactions",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               // TODO: Placeholder for a ListView of recent transactions
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     "Transaction history goes here.",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   // --- Reusable Balance Card Widget ---
//   Widget _buildBalanceCard({
//     required String title,
//     required double amount,
//     required Color color,
//     required IconData icon,
//     String? buttonText,
//     VoidCallback? onPressed,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//                 Icon(icon, color: color, size: 28),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "BD ${amount.toStringAsFixed(3)}", // Format: BD X.XXX
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//
//             if (buttonText != null && onPressed != null) ...[
//               const Divider(height: 30, thickness: 1, color: Colors.grey),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: onPressed,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: color,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: Text(
//                     buttonText,
//                     style: const TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/balance_controller.dart';

class BalanceView extends GetView<BalanceController> {
  const BalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller is initialized here if no binding is used.
    final controller = Get.put(BalanceController());

    return Scaffold(
      // Set the overall screen background to white or light gray
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Assuming your main AppBar style is red
        backgroundColor: const Color(0xffFF3B30),
        foregroundColor: Colors.white,
        title: const Text(
            "Balance Details",
            style: TextStyle(fontWeight: FontWeight.bold)
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This container recreates the main card from your image
              Container(
                decoration: BoxDecoration(
                  // Light grey background for the whole balance block
                  color: const Color(0xffF0F0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Card Header ---
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Balance Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Divider(height: 16, thickness: 1, color: Color(0xffDCDCDC)),

                    // --- Balance Rows ---
                    _buildBalanceRow(
                      context,
                      title: "Total Order Amount",
                      amount: controller.totalOrderAmount.value,
                    ),
                    _buildBalanceRow(
                      context,
                      title: "Withdrawable Balance",
                      amount: controller.withdrawableBalance.value,
                    ),
                    _buildBalanceRow(
                      context,
                      title: "Payable Balance",
                      amount: controller.payableBalance.value,
                      // The payable balance has a slightly darker text in the image
                      amountColor: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Placeholder for other elements below the balance box
              const Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Transaction history goes here.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  // --- Helper Widget to build each row in the balance card ---
  Widget _buildBalanceRow(
      BuildContext context, {
        required String title,
        required double amount,
        Color amountColor = Colors.black,
        FontWeight fontWeight = FontWeight.normal,
      }) {
    // The Row padding should only be horizontal, as the vertical space is implicitly
    // handled by the font size and padding in the parent Container.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Title text
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87, // Dark text
            ),
          ),

          // Right side: Amount text
          Text(
            // Use the provided mock values from your controller.
            // I've used toFixed(2) to match the two decimal places shown in your image (32.00, 390.00)
            amount.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 16,
              fontWeight: fontWeight,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}