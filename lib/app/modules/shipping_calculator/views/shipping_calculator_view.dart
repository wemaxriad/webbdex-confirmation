import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/shipping_calculator_controller.dart';

class ShippingCalculatorView extends StatelessWidget {
  const ShippingCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShippingCalculatorController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shipping Calculator"),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              label: "Select Pick-up Country",
              value: controller.pickupCountry,
              items: controller.countries,
              onChanged: controller.onPickupCountryChanged,
              hint: "Select Pick-up Country",
            ),
            const SizedBox(height: 14),
            _inputField("Pick-up City", controller.pickupCityController, hint: "Pick-up City"),
            const SizedBox(height: 5),
            _buildDropdown(
              label: "Select Drop-off Country",
              value: controller.dropoffCountry,
              items: controller.countries,
              onChanged: controller.onDropoffCountryChanged,
              hint: "Select Drop-off Country",
            ),
            const SizedBox(height: 14),
            _inputField("Drop-off City", controller.dropoffCityController, hint: "Drop-off City"),
            const SizedBox(height: 5),
            _buildDropdown(
              label: "Select Package Type",
              value: controller.packageType,
              items: controller.packageTypes,
              onChanged: controller.onPackageTypeChanged,
              hint: "Select Package Type",
            ),
            const SizedBox(height: 5),
            _buildCalculator(controller),
            const SizedBox(height: 20),
            Obx(() => controller.totalCost.value > 0
                ? _inputField(
                    "Estimated Volumetric Weight (kg)",
                    TextEditingController(
                      text: controller.volumetricWeight.value.toStringAsFixed(3),
                    ),
                    readOnly: true,
                  )
                : const SizedBox()),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Calculate",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculator(ShippingCalculatorController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Weight (kg)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              _buildCalculatorTextField(controller.weightController, "kg"),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDimensionField(
                      "Length (cm)", controller.lengthController, "cm"),
                  const SizedBox(width: 16),
                  _buildDimensionField(
                      "Width (cm)", controller.widthController, "cm"),
                  const SizedBox(width: 16),
                  _buildDimensionField(
                      "Height (cm)", controller.heightController, "cm"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDimensionField(
      String label, TextEditingController textController, String unit) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          _buildCalculatorTextField(textController, unit),
        ],
      ),
    );
  }

  Widget _buildCalculatorTextField(
      TextEditingController textController, String unit) {
    return TextField(
      controller: textController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        suffixText: unit,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFF4B528)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, bool readOnly = false, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          
          controller: controller,
          keyboardType: keyboard,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildDropdown(
      {required String label,
      required RxString value,
      required List<String> items,
      required void Function(String?) onChanged,
      required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
              value: value.value.isEmpty ? null : value.value,
              hint: Text(hint),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            )),
      ],
    );
  }
}
