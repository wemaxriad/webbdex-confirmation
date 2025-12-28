import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/modules/warehouse/model/warehouse_model.dart';

class WarehouseDetailsController extends GetxController {
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

  // Is Active status
  var isActive = true.obs;

late Warehouse warehouse;

  @override
  void onInit() {
    super.onInit();
    warehouse = Get.arguments as Warehouse;
    if (countriesWithCodes.isNotEmpty) {
      selectedCountryWithCode.value = countriesWithCodes[0];
    }
    showWarehouseDetails(warehouse);
  }

 void showWarehouseDetails(Warehouse warehouse) {
    warehouseNameController.text = warehouse.name;
    locationController.text = warehouse.location;
    // Since other details are not in the warehouse model, I'll use dummy data for now.
    firstNameController.text = "John";
    lastNameController.text = "Doe";
    emailController.text = "john.doe@example.com";
    phoneController.text = "1234567890";
    zipCodeController.text = "12345";
    addressController.text = "123, Main Street";
    selectedCountry.value = 'UAE';
    cityOptions.value = citiesByCountry['UAE'] ?? [];
    selectedCity.value = 'Dubai';
    isActive.value = true;

  }

  @override
  void onClose() {
    // Dispose all controllers
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
