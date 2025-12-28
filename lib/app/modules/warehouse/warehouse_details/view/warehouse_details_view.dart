import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/utils/constants/colors.dart';
import '../controller/warehouse_details_controller.dart';

class WarehouseDetailsView extends GetView<WarehouseDetailsController> {
  const WarehouseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Details'),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(controller.warehouseNameController, 'Warehouse Name*'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(controller.firstNameController, 'First Name*'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(controller.lastNameController, 'Last Name*'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(controller.emailController, 'Email'),
            const SizedBox(height: 16),
            _buildPhoneNumberField(),
            const SizedBox(height: 16),
            _buildTextField(controller.locationController, 'Location*'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Country*',
                    selectedValue: controller.selectedCountry,
                    options: controller.countries,
                    onChanged: (String? val){},
                    hint: 'Select Country',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => _buildDropdown(
                        label: 'City*',
                        selectedValue: controller.selectedCity,
                        options: controller.cityOptions.value,
                        onChanged: (String? val){},
                        hint: 'Select City',
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(controller.zipCodeController, 'Zip Code*'),
            const SizedBox(height: 16),
            _buildTextField(controller.addressController, 'Address Information', maxLines: 3),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Is Active',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                Obx(() => Switch(
                      value: controller.isActive.value,
                      onChanged: (val){},
                      activeColor: CustomColor.primaryColor,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1}) {
    final hasAsterisk = labelText.endsWith('*');
    final cleanLabel = labelText.replaceAll(' *', '').replaceAll('*', '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              cleanLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasAsterisk)
              const Text(
                " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: true,
          decoration: InputDecoration(
            hintText: cleanLabel,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              "Phone Number",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              " *",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Phone Number',
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            prefixIcon: Obx(() => DropdownButton<Map<String, String>>(
                  value: controller.selectedCountryWithCode.value.isEmpty ? controller.countriesWithCodes[0] : controller.selectedCountryWithCode.value,
                  underline: const SizedBox.shrink(),
                  items: controller.countriesWithCodes.map((Map<String, String> country) {
                    return DropdownMenuItem<Map<String, String>>(
                      value: country,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(country['flag']!),
                            const SizedBox(width: 4),
                            Text(country['code']!),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: null,
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required RxString selectedValue,
    required List<String> options,
    required void Function(String?) onChanged,
    required String hint,
  }) {
    final hasAsterisk = label.endsWith('*');
    final cleanLabel = label.replaceAll(' *', '').replaceAll('*', '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              cleanLabel,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (hasAsterisk)
              const Text(
                " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => DropdownButtonFormField<String>(
              value: selectedValue.value.isEmpty ? null : selectedValue.value,
              hint: Text(hint),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
