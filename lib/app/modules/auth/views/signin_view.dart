import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/custom_input.dart';
import '../controllers/auth_controller.dart';
import 'signin_slider.dart'; // Ensure this matches your file name

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  // Helper for consistent labels
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xff646464),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //const Colors primaryColor = Colors(0xffFF3B30); // Or your constant primaryColor

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SignInSlider(title: "Login to Continue"),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 33),

                      _label("Email or Username"),
                      CustomInput(
                        controller: controller.emailController,
                        hintText: "Email",
                        icon: 'assets/icons/user.png',
                        validation: (value) => value == null || value.isEmpty ? "Please enter email" : null,
                      ),

                      _label("Password"),
                      CustomInput(
                        controller: controller.passwordController,
                        hintText: "Enter Password",
                        icon: 'assets/icons/lock.png',
                        isPasswordField: true,
                        validation: (value) => value == null || value.isEmpty ? "Please enter password" : null,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Obx(() => CheckboxListTile(
                              activeColor: primaryColor,
                              contentPadding: EdgeInsets.zero,
                              title: const Text("Remember Me", style: TextStyle(color: Color(0xff646464), fontSize: 14)),
                              value: controller.keepLoggedIn.value,
                              onChanged: (val) => controller.keepLoggedIn.value = val!,
                              controlAffinity: ListTileControlAffinity.leading,
                            )),
                          ),
                          InkWell(
                            onTap: () => Get.toNamed(AppRoutes.RESET_PASSWORD),
                            child: const Text("Forgot Password?",
                                style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),

                      const SizedBox(height: 13),

                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value ? null : controller.signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      )),

                      const SizedBox(height: 25),

                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account?  ",
                            style: const TextStyle(color: Color(0xff646464), fontSize: 14),
                            children: [
                              TextSpan(
                                text: "Register",
                                style: const TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
                                recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(AppRoutes.SIGNUP),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
