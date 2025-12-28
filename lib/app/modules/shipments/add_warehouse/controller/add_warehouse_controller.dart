import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/modules/warehouse/controller/warehouse_controller.dart';
import 'package:i_carry/app/modules/warehouse/model/warehouse_model.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/services/shipment_data_service.dart';

class AddWarehouseController extends GetxController {
  // Text Editing Controllers
  final warehouseNameController = TextEditingController();
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

  var isActive = true.obs;
  var isFormValid = false.obs;
  bool get isFromLocationScreen => Get.arguments?['from'] == 'location';


  Warehouse? editingWarehouse;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Warehouse) {
      editingWarehouse = Get.arguments as Warehouse;
      warehouseNameController.text = editingWarehouse!.name;
      locationController.text = editingWarehouse!.location;
      isFormValid.value = true; // Enable save button for editing
    } else {
      // Only add listeners and validate for new warehouses
      warehouseNameController.addListener(validateForm);
      firstNameController.addListener(validateForm);
      lastNameController.addListener(validateForm);
      phoneController.addListener(validateForm);
      locationController.addListener(validateForm);
      zipCodeController.addListener(validateForm);
      selectedCountry.listen((_) => validateForm());
      selectedCity.listen((_) => validateForm());
    }

    if (countriesWithCodes.isNotEmpty) {
      selectedCountryWithCode.value = countriesWithCodes[0];
    }
  }

  void validateForm() {
    if (editingWarehouse != null) {
      isFormValid.value = true;
      return;
    }

    final isValid = warehouseNameController.text.isNotEmpty &&
        firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        zipCodeController.text.isNotEmpty &&
        selectedCountry.isNotEmpty &&
        selectedCity.isNotEmpty;
    isFormValid.value = isValid;
  }

  void onCountrySelected(String? newValue) {
    if (newValue != null && newValue != selectedCountry.value) {
      selectedCountry.value = newValue;
      selectedCity.value = ''; // Reset city
      cityOptions.value = citiesByCountry[newValue] ?? [];
      validateForm(); // Re-validate on change
    }
  }

  void onCitySelected(String? newValue) {
    if (newValue != null) {
      selectedCity.value = newValue;
      validateForm(); // Re-validate on change
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

  void saveWarehouse() {
    if (editingWarehouse == null && !isFormValid.value) return;

    final shipmentDataService = Get.find<ShipmentDataService>();

    final senderData = {
      'name': warehouseNameController.text,
      'Location': locationController.text,
      'Address': addressController.text,
      'City': '${selectedCity.value}, ${selectedCountry.value}',
      'Phone': '${selectedCountryWithCode.value['code']}${phoneController.text}',
      'Email': emailController.text,
    };

    shipmentDataService.senderData.value = senderData;

    if (isFromLocationScreen) {
      Get.back(result: warehouseNameController.text);
      return;
    }
    
    if (editingWarehouse != null) {
      final warehouseController = Get.find<WarehouseController>();
      editingWarehouse!.name = warehouseNameController.text;
      editingWarehouse!.location = locationController.text;
      warehouseController.updateWarehouse(editingWarehouse!);
      Get.back();
      return;
    }

    Get.toNamed(Routes.RECIPIENTS);
  }

  @override
  void onClose() {
    warehouseNameController.dispose();
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
