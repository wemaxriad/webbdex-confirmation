import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ResetPasswordStep { EMAIL, OTP, CHANGE_PASSWORD }

class ResetPasswordController extends GetxController {
  // Step management
  final Rx<ResetPasswordStep> currentStep = ResetPasswordStep.EMAIL.obs;

  // Form keys
  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;

  // --- Step 1: Send OTP ---
  void sendOtp() {
    if (emailFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      // Simulate a network call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        currentStep.value = ResetPasswordStep.OTP;
        Get.snackbar('Success', 'OTP sent to ${emailController.text}');
      });
    }
  }

  // --- Step 2: Verify OTP ---
  void verifyOtp() {
    if (otpFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      // Simulate a network call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        if (otpController.text == '1234') { // Dummy OTP
          currentStep.value = ResetPasswordStep.CHANGE_PASSWORD;
          Get.snackbar('Success', 'OTP verified successfully!');
        } else {
          Get.snackbar('Error', 'Invalid OTP. Please try again.');
        }
      });
    }
  }

  // --- Step 3: Change Password ---
  void changePassword() {
    if (passwordFormKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      // Simulate a network call
      Future.delayed(const Duration(seconds: 2), () {
        isLoading.value = false;
        Get.back(); // Go back to the previous screen (e.g., sign-in)
        Get.snackbar('Success', 'Password changed successfully!');
      });
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
