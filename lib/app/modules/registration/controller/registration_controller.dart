import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  // Text Editing Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final newIndustryController = TextEditingController();

  // Dropdown options
  final List<String> industryOptions = [
    'Fashion',
    'Beauty & Cosmetic',
    'Electronics',
    'Other' // For adding a new industry
  ];

  // Observables
  var selectedIndustry = 'Fashion'.obs;
  var showNewIndustryField = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in the selected industry to show/hide the custom field
    ever(selectedIndustry, (String value) {
      showNewIndustryField.value = value == 'Other';
    });
  }

  void register() {
    // Implement registration logic here
    // For now, it will just print the values
    final industry = selectedIndustry.value == 'Other'
        ? newIndustryController.text
        : selectedIndustry.value;

    print('First Name: ${firstNameController.text}');
    print('Last Name: ${lastNameController.text}');
    print('Email: ${emailController.text}');
    print('Phone: ${phoneController.text}');
    print('Company Name: ${companyNameController.text}');
    print('Company Email: ${companyEmailController.text}');
    print('Industry: $industry');
    print('Password: ${passwordController.text}');

    // You could navigate to another screen here, e.g.:
    // Get.offAllNamed(Routes.DASHBOARD);
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    companyNameController.dispose();
    companyEmailController.dispose();
    passwordController.dispose();
    newIndustryController.dispose();
    super.onClose();
  }
}
