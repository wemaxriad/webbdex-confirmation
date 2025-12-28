import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/utils/constants/colors.dart';
import '../controllers/create_shipment_controller.dart';

class CreateShipmentView extends GetView<CreateShipmentController> {
  const CreateShipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Create Shipment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Section 1: Sender's Information
                  _buildSectionContainer(
                    title: "Sender's Information",
                    subTitle: "Sender details",
                    child: _buildSenderCard(),
                  ),
                  const SizedBox(height: 16),

                  // Section 2: Recipient's Information
                  _buildSectionContainer(
                    title: "Recipient's Information",
                    subTitle: "Recipient details",
                    child: _buildRecipientCard(),
                  ),
                  const SizedBox(height: 16),

                  // Section 3: Order Details
                  _buildSectionContainer(
                    title: "Order Details",
                    child: _buildOrderDetailsContent(),
                  ),
                ],
              ),  
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  controller.processShipment();
                  Get.offNamed(Routes.SHIPMENTS);
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  // --- SECTION CONTAINER HELPER ---
  Widget _buildSectionContainer({
    required String title,
    String? subTitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          if (subTitle != null) ...[
            Text(
              subTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  // --- DATA CARDS (Sender & Recipient) ---
  Widget _buildSenderCard() {
    return Obx(() => _buildInfoBox(
      icon: Icons.person_outline,
      name: controller.senderInfo['name'] ?? '',
      details: {
        "Location": controller.senderInfo['Location'] ?? '',
        "Address": controller.senderInfo['Address'] ?? '',
        "City": controller.senderInfo['City'] ?? '',
        "Phone": controller.senderInfo['Phone'] ?? '',
        "Email": controller.senderInfo['Email'] ?? '',
      },
    ));
  }

  Widget _buildRecipientCard() {
    return Obx(() => _buildInfoBox(
      icon: Icons.location_on_outlined,
      name: controller.recipientInfo['name'] ?? '',
      details: {
        "Location": controller.recipientInfo['Location'] ?? '',
        "Address": controller.recipientInfo['Address'] ?? '',
        "City": controller.recipientInfo['City'] ?? '',
        "Phone": controller.recipientInfo['Phone'] ?? '',
        "Email": controller.recipientInfo['Email'] ?? '',
      },
    ));
  }

  // --- ORDER DETAILS CONTENT ---
  Widget _buildOrderDetailsContent() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Selected Carrier", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.speed, color: Colors.red, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((controller.orderDetails['carrierName'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text((controller.orderDetails['carrierService'] ?? '').toString(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text((controller.orderDetails['carrierDelivery'] ?? '').toString(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text((controller.orderDetails['totalCharges'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  const Text("Total Charges", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("Weight & Dimensions", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((controller.orderDetails['packageName'] ?? '').toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDetailRow("Dimensions", (controller.orderDetails['dimensions'] ?? '').toString()),
              _buildDetailRow("Weight", (controller.orderDetails['weight'] ?? '').toString()),
              _buildDetailRow("Quantity", (controller.orderDetails['quantity'] ?? '').toString()),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text("Description", style: TextStyle(fontWeight: FontWeight.w600)),
        Text((controller.orderDetails['description'] ?? '').toString(), style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 20),
        const Text("Additional Information", style: TextStyle(fontWeight: FontWeight.w600)),
        Text((controller.orderDetails['additionalInfo'] ?? '').toString(), style: const TextStyle(fontSize: 14)),
      ],
    ));
  }

  Widget _buildInfoBox({required IconData icon, required String name, required Map<String, String> details}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...details.entries.map((e) => _buildDetailRow(e.key, e.value)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
