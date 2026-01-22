import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constant_colors.dart';
import '../controller/order_controller.dart';
import '../model/orderDetailsModel.dart';

class OrderDetailsView extends StatelessWidget {

  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyOrdersController());
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Obx(() {
        if (controller.isLoading.isTrue || controller.orderDetails.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final Order order = controller.orderDetails.value!;

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
                          " ${order.totalAmount}",
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
                    _row("Preferred Language", order.confirmationPreferredLanguage??''),
                    _divider(),
                    _row("Customer", " ${order.subtotal}"),
                    _divider(),
                    _row("Subtotal", " ${order.subtotal}"),
                    _divider(),
                    _row("Tax", " ${order.productTax}"),
                    _divider(),
                    _row("Shipping Cost", " ${order.shippingCost}"),
                    _divider(),
                    _row(
                      "Payment method",
                      order.paymentStatus.toString(),
                    ),
                    _divider(),
                    _row("Total", " ${order.totalAmount}", bold: true),
                  ],
                ),
              ),

              /// ================= CONFIRMATION INFO =================
              SizedBox(height: 10,),
              if(order.confirmationDate !=null)
              _card(
                title: "Confirmation Information",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row("Preferred Language", order.confirmationPreferredLanguage??''),
                    _divider(),
                    _row("Confirmation Date", order.confirmationDate??''),
                    _divider(),

                    if (order.confirmationCallNote !=null) ...[
                      const SizedBox(height: 8),
                      const Text(
                        "Call Note",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(order.confirmationCallNote??''),
                    ],

                    if (order.confirmationCallRecord!=null) ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: open audio player
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Play Call Recording"),
                      ),
                    ],

                    if (order.confirmationCallImage !=null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          order.confirmationCallImage??'',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ),
              ),


              const SizedBox(height: 16),

              /// ================= PRODUCTS =================
              _card(
                title: "Products",
                child: Column(
                  children: order.orderDetails!.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text("Quantity: ${item.qty}"),
                          Text("Price:  ${item.price}"),
                          const SizedBox(height: 6),
                          Text(
                            "Subtotal:  ${item.subtotal}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 12),

                          /// Refund Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // TODO refund logic
                            },
                            child: const Text(
                              "Request Refund",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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

