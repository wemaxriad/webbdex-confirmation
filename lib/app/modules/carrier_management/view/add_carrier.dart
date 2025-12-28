import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/modules/carrier_management/controller/add_carrier_controller.dart';
import 'package:i_carry/app/modules/carrier_management/controller/carrier_management_controller.dart';
import 'package:i_carry/app/utils/constants/colors.dart';

class AddCarrierView extends GetView<AddCarrierController> {
  const AddCarrierView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CarrierManagementController carrierManagementController = Get.find();
    final arguments = Get.arguments as Map<String, dynamic>?;
    final isEditMode = arguments?['isEditMode'] ?? false;
    final carrierData = arguments?['carrierData'] as Map<String, dynamic>?;
    final index = arguments?['index'] as int?;

    if (isEditMode && carrierData != null) {
      controller.selectedCarrier.value = carrierData['name'];
      controller.websiteController.text = carrierData['website'] ?? '';
      controller.phoneController.text = carrierData['phone'] ?? '';
      controller.emailController.text = carrierData['email'] ?? '';
      controller.descriptionController.text = carrierData['description'] ?? '';
      controller.addressController.text = carrierData['address'] ?? '';
      controller.isActive.value = carrierData['status'] == 'Active';

      final configuration = carrierData['configuration'] as Map<String, dynamic>?;
      if (configuration != null) {
        controller.apiKeyController.text = configuration['api_key'] ?? '';
        controller.secretKeyController.text = configuration['secret_key'] ?? '';
        controller.shippingLocationController.text = configuration['shipping_location'] ?? '';
        controller.accountController.text = configuration['account'] ?? '';
        controller.testUrlController.text = configuration['test_url'] ?? '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text(isEditMode ? 'Update Carrier' : 'Add Carrier'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Carrier Details'),
            const SizedBox(height: 16),
            _buildDropdownField('Carrier*', controller.carriers, controller.selectedCarrier),
            const SizedBox(height: 16),
            _buildTextField(controller.websiteController, 'Website'),
            const SizedBox(height: 16),
            _buildTextField(controller.phoneController, 'Phone Number'),
            const SizedBox(height: 16),
            _buildTextField(controller.emailController, 'Email Address'),
            const SizedBox(height: 16),
            _buildTextField(controller.descriptionController, 'Description', maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(controller.addressController, 'Address'),
            const SizedBox(height: 24),
            _buildActiveSwitch(),
            const SizedBox(height: 16),
            _buildExpansionTile('Carrier Configuration'),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(carrierManagementController, isEditMode, index),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildDropdownField(String label, List<String> items, RxString selectedItem) {
    final hasAsterisk = label.endsWith('*');
    final cleanLabel = label.replaceAll(' *', '').replaceAll('*', '');

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
        Obx(() => DropdownButtonFormField<String>(
          value: selectedItem.value,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: (value) {
            if (value != null) {
              selectedItem.value = value;
            }
          },
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

  Widget _buildActiveSwitch() {
    return Obx(() => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Active', style: TextStyle(fontWeight: FontWeight.w500)),
      value: controller.isActive.value,
      onChanged: (value) => controller.isActive.value = value,
      activeColor: CustomColor.secondaryColor,
    ));
  }

  Widget _buildExpansionTile(String title) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      initiallyExpanded: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Two-column layout for larger screens
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(controller.apiKeyController, 'Api Key'),
                          const SizedBox(height: 16),
                          _buildTextField(controller.shippingLocationController, 'Shipping Location'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildTextField(controller.secretKeyController, 'Secret Key'),
                          const SizedBox(height: 16),
                          _buildTextField(controller.accountController, 'Account'),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Single-column layout for smaller screens
                return Column(
                  children: [
                    _buildTextField(controller.apiKeyController, 'Api Key'),
                    const SizedBox(height: 16),
                    _buildTextField(controller.secretKeyController, 'Secret Key'),
                    const SizedBox(height: 16),
                    _buildTextField(controller.shippingLocationController, 'Shipping Location'),
                    const SizedBox(height: 16),
                    _buildTextField(controller.accountController, 'Account'),
                  ],
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildTextField(controller.testUrlController, 'Test Url'),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(CarrierManagementController carrierManagementController, bool isEditMode, int? index) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.secondaryColor,
              ),
              onPressed: () {
                if (controller.selectedCarrier.value == 'Select an option') {
                  Get.snackbar(
                    'Validation Error',
                    'Carrier is a required field.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  final newCarrierData = {
                    'name': controller.selectedCarrier.value,
                    'status': controller.isActive.value ? 'Active' : 'Inactive',
                    'lastUpdated': DateTime.now(),
                    'email': controller.emailController.text,
                    'website': controller.websiteController.text,
                    'phone': controller.phoneController.text,
                    'description': controller.descriptionController.text,
                    'address': controller.addressController.text,
                    'configuration': {
                      'api_key': controller.apiKeyController.text,
                      'secret_key': controller.secretKeyController.text,
                      'shipping_location': controller.shippingLocationController.text,
                      'account': controller.accountController.text,
                      'test_url': controller.testUrlController.text
                    }
                  };
                  if (isEditMode) {
                    carrierManagementController.updateCarrier(index!, newCarrierData);
                  } else {
                    carrierManagementController.addCarrier(newCarrierData);
                  }
                  Get.back();
                }
              },
              child: Text(isEditMode ? 'Update Carrier' : 'Add Carrier', style: const TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
