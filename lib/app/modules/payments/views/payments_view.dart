// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/payments_controller.dart';

class PaymentsView extends StatelessWidget {
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentsController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.paymentList.isEmpty) {
          return const Center(child: Text("No payments found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.paymentList.length,
          itemBuilder: (context, index) {
            final item = controller.paymentList[index];

            return Card(
              elevation: 1.5,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: item["status"] == "Paid"
                      ? Colors.green
                      : Colors.orange,
                  child: const Icon(Icons.payment, color: Colors.white),
                ),
                title: Text("Payment ID: ${item['id']}"),
                subtitle: Text(
                  "${item['status']} • ${item['date']}",
                ),
                trailing: Text(
                  "৳${item['amount']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

