import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CompanyProfileController extends GetxController {
  RxBool isLoading = false.obs;

  // Form controllers
  TextEditingController companyName = TextEditingController();
  TextEditingController companyEmail = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController website = TextEditingController();

  @override
  void onInit() {
    loadProfileData();
    super.onInit();
  }

  void loadProfileData() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 800));

    companyName.text = "iCARRY Express Ltd";
    companyEmail.text = "support@icarry.com";
    phone.text = "+880 1789 000000";
    address.text = "Dhaka, Bangladesh";
    website.text = "https://icarry.com";

    isLoading.value = false;
  }

  void saveProfile() {
    Get.snackbar(
      "Saved",
      "Company profile updated successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
