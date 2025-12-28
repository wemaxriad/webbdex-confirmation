
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        title: const Text("Orders", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar and Filter
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      onChanged: controller.filterOrders,
                      decoration: const InputDecoration(
                        hintText: "Search by Order Number",
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Orders List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Orders Found",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: controller.filteredList.length,
                  itemBuilder: (context, index) {
                    final order = controller.filteredList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order #${order.orderId}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                _buildStatusTag(order.status, Colors.grey.shade300, Colors.black),
                              ],
                            ),
                            const Divider(height: 24),
                            _buildDetailRow('Order Type', order.orderType,
                                tag: _buildStatusTag(order.orderType, Colors.green.shade100, Colors.green)),
                            _buildDetailRow('Total Amount', '\$${order.totalAmount}'),
                            _buildDetailRow('Payment Status', order.paymentStatus,
                                tag: _buildStatusTag(order.paymentStatus, Colors.orange.shade100, Colors.orange)),
                            _buildDetailRow('Order Date', order.date),
                            _buildDetailRow('Tracking Number', order.trackingNumber),
                            _buildDetailRow(
                              'Carrier',
                              order.carrier,
                              tag: Row(
                                children: [
                                  const Icon(Icons.visibility, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(order.carrier, style: const TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Widget? tag}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          tag ?? Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
