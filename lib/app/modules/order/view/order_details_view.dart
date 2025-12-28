import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_details_controller.dart';
import '../../../model/order_model.dart';

class OrderDetailsView extends StatelessWidget {
  final int orderId;

  const OrderDetailsView({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailsController(orderId));

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xffFF3B30),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Order Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue || controller.order.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final Order order = controller.order.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= ORDER SUMMARY =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order #${order.id}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "SAR ${order.total}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF3B30),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _statusChip(
                          "Payment: ${order.paymentStatus}",
                          Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _statusChip(
                          "Order: ${order.status}",
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= ORDER DETAILS =================
              _card(
                title: "Order Details",
                child: Column(
                  children: [
                    _row("Subtotal", "SAR ${order.subtotal}"),
                    _divider(),
                    _row("Coupon Discount", "SAR ${order.discount}"),
                    _divider(),
                    _row("Tax", "SAR ${order.tax}"),
                    _divider(),
                    _row("Shipping Cost", "SAR ${order.shippingCost}"),
                    _divider(),
                    _row(
                      "Payment method",
                      order.paymentMethod.replaceAll("_", " "),
                    ),
                    _divider(),
                    _row("Total", "SAR ${order.total}", bold: true),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// ================= PRODUCTS =================
              _card(
                title: "Products",
                child: Column(
                  children: List.generate(order.items.length, (index) {
                    final item = order.items[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Quantity: ${item.qty}"),
                        const SizedBox(height: 10),

                        /// Refund Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // TODO: refund request logic
                          },
                          child: const Text(
                            "Request Refund",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        if (index != order.items.length - 1)
                          const Divider(height: 32),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ================= HELPER WIDGETS =================

  static Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  static Widget _row(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left),
          Text(
            right,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _divider() =>
      Divider(color: Colors.grey.shade300);

  static Widget _statusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

