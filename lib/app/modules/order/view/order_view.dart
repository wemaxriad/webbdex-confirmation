// import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/order_controller.dart';
//
// class MyOrdersView extends GetView<MyOrdersController> {
//   const MyOrdersView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       backgroundColor: const Color(0xffF5F5F5),
//       appBar: AppBar(
//           backgroundColor: primaryColor,
//           title: const Text("My Orders")),
//       body: Obx(() {
//         if (controller.allOrders.isEmpty) {
//           return const Center(child: Text("No orders found"));
//         }
//
//         return ListView.separated(
//           padding: const EdgeInsets.all(16),
//           itemCount: controller.allOrders.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 10),
//           itemBuilder: (_, index) {
//             final order = controller.allOrders[index];
//
//             return Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(child: Text("${order.id}")),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Order #${order.id}",
//                             style: const TextStyle(fontWeight: FontWeight.bold)),
//                         Text(order.status,
//                             style: const TextStyle(color: Colors.grey)),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/order_controller.dart';
import '../controller/order_details_controller.dart';
import 'order_details_view.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.allOrders.isEmpty) {
          return const Center(child: Text("No orders found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.allOrders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final order = controller.allOrders[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),

              // ✅ Navigate to Order Details
              onTap: () {
                //Get.to(() => OrderDetailsView(orderId: order.id));
                // Get.to(
                //       () => OrderDetailsView(orderId: order.id!),
                //   binding: BindingsBuilder(() {
                //     Get.put(OrderDetailsController(order.id));
                //   }),
                // );

              },

              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Order ID
                    CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.1),
                      child: Text(
                        "${order!.id}",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Order Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order #${order!.id}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order!.status.toString(),
                            style: TextStyle(
                              color: _statusColor(order!.status.toString()),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 📞 Call Button
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => openDialPad("01743333169"),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// 📞 Open phone dial pad
  Future<void> openDialPad(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Get.snackbar("Error", "Could not open dial pad");
    }
  }


  /// Status color helper
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

