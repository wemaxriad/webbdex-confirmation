// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// import '../../../routes/app_routes.dart';
//
// class AuthController extends GetxController {
//   // Form keys for login and signup
//   final formKey = GlobalKey<FormState>();
//   final signupFormKey = GlobalKey<FormState>();
//
//   // TextFields controllers
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   final signupEmailController = TextEditingController();
//   final signupPasswordController = TextEditingController();
//
//   // Reactive states
//   var isLoading = false.obs;
//   var passwordVisible = false.obs;
//   var keepLoggedIn = true.obs;
//
//   // ------------------------- LOGIN -------------------------
//   void signIn() async {
//     if (!formKey.currentState!.validate()) {
//       return; // Form validation failed
//     }
//
//     isLoading(true);
//
//     await Future.delayed(const Duration(seconds: 1)); // simulate API call
//
//     isLoading(false);
//
//     Get.snackbar("Success", "Logged in successfully");
//
//     Get.offAllNamed(AppRoutes.DASHBOARD);
//   }
//
//   // ------------------------- SIGNUP -------------------------
//   void signUp() async {
//     if (!signupFormKey.currentState!.validate()) {
//       return; // Form validation failed
//     }
//
//     isLoading(true);
//
//     await Future.delayed(const Duration(seconds: 1)); // simulate API call
//
//     isLoading(false);
//
//     Get.snackbar("Success", "Account created successfully");
//     Get.back(); // go back to SignIn
//   }
//
//   // Toggle password visibility in both login and signup (if needed)
//   void togglePasswordVisibility() {
//     passwordVisible.value = !passwordVisible.value;
//   }
//
//   @override
//   void onClose() {
//     emailController.dispose();
//     passwordController.dispose();
//     signupEmailController.dispose();
//     signupPasswordController.dispose();
//     super.onClose();
//   }
// }

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  // Form keys for login and signup
  final formKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // TextFields controllers for login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // TextFields controllers for signup
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Reactive states
  var isLoading = false.obs;
  var passwordVisible = false.obs;
  var keepLoggedIn = true.obs;
  var termsAgree = false.obs;

  // ------------------------- LOGIN -------------------------
  void signIn() async {
    if (!formKey.currentState!.validate()) {
      return; // Form validation failed
    }

    isLoading(true);

    await Future.delayed(const Duration(seconds: 1)); // simulate API call

    isLoading(false);

    Get.snackbar("Success", "Logged in successfully");

    Get.offAllNamed(AppRoutes.DASHBOARD);
  }

  // ------------------------- SIGNUP -------------------------
  void signUp() async {
    if (!signupFormKey.currentState!.validate()) {
      return; // Form validation failed
    }

    if (!termsAgree.value) {
      Get.snackbar("Terms", "You must agree to the terms to continue");
      return;
    }

    isLoading(true);

    await Future.delayed(const Duration(seconds: 1)); // simulate API call

    isLoading(false);

    Get.snackbar("Success", "Account created successfully");
    Get.back(); // go back to SignIn
  }

  // Toggle password visibility in both login and signup (if needed)
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  // You may want to add toggle for termsAgree from UI too
  void toggleTermsAgree(bool? value) {
    if (value != null) termsAgree.value = value;
  }

  @override
  void onClose() {
    // Dispose all controllers
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    signupEmailController.dispose();
    phoneController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

