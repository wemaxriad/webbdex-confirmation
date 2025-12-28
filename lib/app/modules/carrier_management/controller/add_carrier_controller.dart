import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCarrierController extends GetxController {
  final isActive = true.obs;

  final websiteController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  final apiKeyController = TextEditingController();
  final secretKeyController = TextEditingController();
  final shippingLocationController = TextEditingController();
  final accountController = TextEditingController();
  final testUrlController = TextEditingController();

  final selectedCarrier = 'Select an option'.obs;
  final carriers = ['Select an option', 'Fedex', 'UPS'];

  @override
  void onClose() {
    websiteController.dispose();
    phoneController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    apiKeyController.dispose();
    secretKeyController.dispose();
    shippingLocationController.dispose();
    accountController.dispose();
    testUrlController.dispose();
    super.onClose();
  }
}
