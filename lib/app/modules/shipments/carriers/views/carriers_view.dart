import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/utils/constants/colors.dart';

import '../controller/carriers_controller.dart';

class CarriersView extends GetView<CarriersController> {
  const CarriersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Select a Carrier",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  25,
                  16,
                  16,
                ), // 👈 top = 10
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCodSection(),
                    const SizedBox(height: 32),
                    _buildCarrierSelectionSection(),

                    // Prevent content hiding behind button
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            // Fixed bottom button
            Padding(
              padding: const EdgeInsets.all(16),
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
                  onPressed: controller.goToCreateShipment, // <-- CORRECTED
                  child: const Text(
                    "Next",
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
      ),
    );
  }

  Widget _buildCodSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: controller.isCod.value,
                        onChanged: controller.toggleCod,
                        activeColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "COD (Cash On Delivery)*",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                if (controller.isCod.value) ...[
                  const SizedBox(height: 16),
                  const Text("Cod currency*", style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  const Text("Cod amount*", style: TextStyle(fontSize: 13)),
                  const SizedBox(height: 8),
                  _buildAmountField(),
                ],
              ],
            ),
          ),
        ),
        _buildLabel("COD Section"),
      ],
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedCurrency.value,
            items: controller.currencies.map((String val) {
              return DropdownMenuItem(value: val, child: Text(val));
            }).toList(),
            onChanged: controller.updateCurrency,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: controller.amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixIcon: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(right: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Obx(
            () => Text(
              controller.selectedCurrency.value,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildCarrierSelectionSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(10, 24, 10, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: controller.findCarriers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Find carriers",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterAndListContainer(),
            ],
          ),
        ),
        _buildLabel("Carrier Selection"),
      ],
    );
  }

  Widget _buildFilterAndListContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildTab("Fastest", Icons.bolt),
                _buildTab("Best Priced", Icons.monetization_on_outlined),
                _buildTab("Best Rated", Icons.star_border),
              ],
            ),
          ),
          const Divider(height: 1),
          Obx(
            () => controller.showCarriers.value
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: controller.carriers
                          .map((c) => _buildCarrierCard(c))
                          .toList(),
                    ),
                  )
                : const SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrierCard(Map<String, dynamic> carrier) {
    return Obx(
      () => Row(
        children: [
          Radio<String>(
            value: carrier['id'],
            groupValue: controller.selectedCarrierId.value,
            onChanged: (val) => controller.selectedCarrierId.value = val!,
            activeColor: CustomColor.primaryColor,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Image.network(
                    carrier['logo'],
                    width: 40,
                    height: 40,
                    errorBuilder: (c, e, s) => const Icon(Icons.local_shipping),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carrier['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          carrier['subName'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Estimated Delivery",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        carrier['delivery'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Total Charges",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        carrier['price'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, IconData icon) {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: () => controller.selectedFilter.value = title,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: controller.selectedFilter.value == title
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: controller.selectedFilter.value == title
                    ? CustomColor.primaryColor
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: controller.selectedFilter.value == title
                      ? CustomColor.primaryColor
                      : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: controller.selectedFilter.value == title
                        ? CustomColor.primaryColor
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildLabel(String text) {
    return Positioned(
      top: -10,
      left: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.white,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
