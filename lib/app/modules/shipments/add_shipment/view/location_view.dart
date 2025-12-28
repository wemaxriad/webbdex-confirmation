import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/utils/constants/colors.dart';
import '../../add_recipients/bindings/recipients_binding.dart';
import '../../add_recipients/view/add_recipient_view.dart';
import '../controller/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Location",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset(
              'assets/images/flag.png', // make sure this path is correct
              width: 28,
            ),
          )
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -------- GOOGLE MAP (DEMO PLACEHOLDER) --------
            SizedBox(
              height: 280,
              child: Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    "Google Map Placeholder\n(API Key Required)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // -------- FORM --------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // PICKUP
                  _buildLocationDropdown(
                    title: "Pick-up Location",
                    hint: "Warehouse",
                    value: controller.pickupLocation,
                    items: controller.warehouseLocations,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.setPickup(newValue);
                      }
                    },
                    onAddPressed: () async {
                      final newWarehouseName = await Get.toNamed(
                        Routes.ADD_WAREHOUSE,
                        arguments: {'from': 'location'}, // Pass argument to specify the origin
                      );
                      if (newWarehouseName != null && newWarehouseName is String) {
                        controller.addWarehouse(newWarehouseName); // Add to the list
                        controller.setPickup(newWarehouseName);    // Set as selected
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // DROPOFF
                  _buildLocationDropdown(
                    title: "Drop-off Location",
                    hint: "Recipient",
                    value: controller.dropoffLocation,
                    items: controller.recipientLocations,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        controller.setDropoff(newValue);
                      }
                    },
                    onAddPressed: () async {
                       final newRecipientName = await Get.toNamed(
                        Routes.RECIPIENTS,
                        arguments: {'from': 'location'}, // Pass argument to specify the origin
                      );
                      if (newRecipientName != null && newRecipientName is String) {
                        controller.addRecipient(newRecipientName); // Add to the list
                        controller.setDropoff(newRecipientName);    // Set as selected
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------------- NEXT BUTTON ----------------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final isEnabled = controller.pickupLocation.isNotEmpty &&
              controller.dropoffLocation.isNotEmpty;
          return SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isEnabled ? CustomColor.primaryColor : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isEnabled
                  ? () {
                      Get.toNamed(Routes.SHIPMENT_DETAILS);
                    }
                  : null,
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------------- LOCATION DROPDOWN WIDGET ----------------
  Widget _buildLocationDropdown({
    required String title,
    required String hint,
    required RxString value,
    required RxList<String> items, // Changed to RxList
    required void Function(String?) onChanged,
    required VoidCallback onAddPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              " *",
              style: TextStyle(color: Colors.red),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add, color: CustomColor.primaryColor),
              onPressed: onAddPressed,
            )
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              value: value.isEmpty ? null : value.value,
              hint: Text(hint, style: TextStyle(color: Colors.grey.shade500)),
              isExpanded: true,
              items: items.map((String location) { // Now observes changes in items
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            )),
      ],
    );
  }
}
