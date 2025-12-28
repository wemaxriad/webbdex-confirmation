import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/services/shipment_data_service.dart';

class AddRecipientController extends GetxController {
  // Text Editing Controllers
  final recipientNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();

  // Dropdown data
  final List<String> countries = ['UAE', 'USA', 'UK'];
  final Map<String, List<String>> citiesByCountry = {
    'UAE': ['Dubai', 'Abu Dhabi', 'Sharjah'],
    'USA': ['New York', 'Los Angeles', 'Chicago'],
    'UK': ['London', 'Manchester', 'Liverpool'],
  };
  final List<Map<String, String>> countriesWithCodes = [
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'USA', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'UK', 'code': '+44', 'flag': '🇬🇧'},
  ];

  // Dropdown observables
  var selectedCountry = ''.obs;
  var selectedCity = ''.obs;
  var cityOptions = <String>[].obs;
  var selectedCountryWithCode = <String, String>{}.obs;

  // Is Active status
  var isActive = true.obs;

  // Form validation status
  var isFormValid = false.obs;
  bool get isFromLocationScreen => Get.arguments?['from'] == 'location';


  @override
  void onInit() {
    super.onInit();
    if (countriesWithCodes.isNotEmpty) {
      selectedCountryWithCode.value = countriesWithCodes[0];
    }

    // Add listeners to all mandatory fields
    recipientNameController.addListener(validateForm);
    firstNameController.addListener(validateForm);
    lastNameController.addListener(validateForm);
    phoneController.addListener(validateForm);
    locationController.addListener(validateForm);
    zipCodeController.addListener(validateForm);
    selectedCountry.listen((_) => validateForm());
    selectedCity.listen((_) => validateForm());
  }

  void validateForm() {
    final isValid =
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        zipCodeController.text.isNotEmpty &&
        selectedCountry.isNotEmpty ;
    isFormValid.value = isValid;
  }

  void onCountrySelected(String? newValue) {
    if (newValue != null && newValue != selectedCountry.value) {
      selectedCountry.value = newValue;
      selectedCity.value = '';
      cityOptions.value = citiesByCountry[newValue] ?? [];
    }
  }

  void onCitySelected(String? newValue) {
    if (newValue != null) {
      selectedCity.value = newValue;
    }
  }

    void onCountryCodeSelected(Map<String, String>? newValue) {
    if (newValue != null) {
      selectedCountryWithCode.value = newValue;
    }
  }


  void toggleIsActive(bool value) {
    isActive.value = value;
  }

  void saveRecipient() {
    if (!isFormValid.value) return;

    final shipmentDataService = Get.find<ShipmentDataService>();

    final recipientData = {
      'name': '${firstNameController.text} ${lastNameController.text}',
      'Location': locationController.text,
      'Address': addressController.text,
      'City': '${selectedCity.value}, ${selectedCountry.value}',
      'Phone': '${selectedCountryWithCode.value['code']}${phoneController.text}',
      'Email': emailController.text,
    };
    
    shipmentDataService.recipientData.value = recipientData;

    if (isFromLocationScreen) {
      final fullName = '${firstNameController.text} ${lastNameController.text}';
      Get.back(result: fullName);
      return;
    }

    Get.toNamed(Routes.SHIPMENT_DETAILS);
  }

  @override
  void onClose() {
    // Dispose all controllers
    recipientNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    zipCodeController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
