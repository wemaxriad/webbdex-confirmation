import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import '../../../utils/constants/colors.dart';
import '../controller/shipment_controller.dart';

class ShipmentsView extends StatelessWidget {
  const ShipmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShipmentsController>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (value) => controller.searchText.value = value,
              decoration: InputDecoration(
                hintText: "Search by tracking, status, etc.",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.shipmentsList.isEmpty) {
                return const Center(child: Text("No shipments found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.shipmentsList.length,
                itemBuilder: (context, index) {
                  final item = controller.shipmentsList[index];
                  final trackingId = item['tracking']?.toString() ?? '';

                  return Obx(() {
                    final isExpanded = controller.expandedTrackingId.value == trackingId;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "# $trackingId",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(item['date'] ?? ''),
                            trailing: IconButton(
                              icon: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                              onPressed: () => controller.toggleExpand(trackingId),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              height: 34,
                              decoration: BoxDecoration(
                                color: CustomColor.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  item['status'] ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (isExpanded) ...[
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "CARRIER",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['carrier'] ?? '-',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "SENDER",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['sender'] ?? '-',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "RECIPIENT",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['recipient'] ?? '-',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: const [
                                    Icon(Icons.circle, size: 10),
                                    SizedBox(height: 4),
                                    SizedBox(
                                      height: 30,
                                      child: VerticalDivider(thickness: 1),
                                    ),
                                    Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['from'] ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['to'] ?? '',
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor.primaryColor,
        onPressed: () {
          Get.toNamed(Routes.LOCATION);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
