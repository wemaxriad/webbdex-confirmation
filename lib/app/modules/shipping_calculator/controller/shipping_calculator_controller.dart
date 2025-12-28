import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ShippingCalculatorController extends GetxController {
  // Observables for UI state
  RxDouble totalCost = 0.0.obs;

  // State for country and city dropdowns
  final pickupCountry = "".obs;
  final dropoffCountry = "".obs;

  // Text editing controllers for city inputs
  final pickupCityController = TextEditingController();
  final dropoffCityController = TextEditingController();

  // State for package type
  final packageType = "".obs; // Set to empty to show hint
  final packageTypes = ["Parcel", "Document"];

  // Mock data for countries
  final countries = ["USA", "Canada", "UK"];

  // Controllers for calculator
  final weightController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();

  // Observables for calculated weights
  final grossWeight = 0.0.obs;
  final volumetricWeight = 0.0.obs;
  final chargeableWeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to reset cost when inputs change
    weightController.addListener(_resetCalculation);
    lengthController.addListener(_resetCalculation);
    widthController.addListener(_resetCalculation);
    heightController.addListener(_resetCalculation);
    pickupCityController.addListener(_resetCalculation);
    dropoffCityController.addListener(_resetCalculation);
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    pickupCityController.dispose();
    dropoffCityController.dispose();
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.onClose();
  }

  void _resetCalculation() {
    if (totalCost.value > 0) {
      totalCost.value = 0.0;
    }
  }

  void _updateWeights() {
    final weight = double.tryParse(weightController.text) ?? 0;
    final length = double.tryParse(lengthController.text) ?? 0;
    final width = double.tryParse(widthController.text) ?? 0;
    final height = double.tryParse(heightController.text) ?? 0;

    grossWeight.value = weight;

    // Always calculate volumetric weight since the calculator is always visible
    volumetricWeight.value = (length * width * height) / 5000;

    // Chargeable weight is the greater of the two, this may be adjusted based on package type later
    chargeableWeight.value = max(grossWeight.value, volumetricWeight.value);
  }

  void onPickupCountryChanged(String? newValue) {
    if (newValue != null) {
      pickupCountry.value = newValue;
      _resetCalculation();
    }
  }

  void onDropoffCountryChanged(String? newValue) {
    if (newValue != null) {
      dropoffCountry.value = newValue;
      _resetCalculation();
    }
  }

  void onPackageTypeChanged(String? newValue) {
    if (newValue != null) {
      packageType.value = newValue;
      _resetCalculation();
    }
  }

  void calculate() {
    _updateWeights(); // Ensure weights are current
    double weight = chargeableWeight.value;

    if (weight <= 0) {
      Get.snackbar(
        "Invalid Input",
        "Please enter a valid weight",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Simplified calculation
    double cost = 50 + (weight * 10);

    totalCost.value = cost;
  }
}
