import 'package:confirmation_agent_app/app/modules/auth/controllers/signup_controller.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/components/dropdowns/country_states_dropdowns.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/signin_slider.dart';
import 'package:confirmation_agent_app/app/routes/app_routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/common_helper.dart';
import '../../../utils/const_strings.dart';
import '../../../utils/constant_colors.dart';
import '../../../utils/custom_input.dart';
import '../controllers/auth_controller.dart';
import 'components/email_name_fields.dart';
import 'components/signup_phone_pass.dart';

class SignupPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final SignUpController signUpController = Get.put(SignUpController());

  // Declare controllers internally
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final RxBool termsAgree = false.obs;

  SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: authController.signupFormKey,
            child: Column(
              children: [
                SignInSlider(title: ConstString.signUpToContinue),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 33),
                      EmailNameFields(
                        fullNameController: fullNameController,
                        userNameController: userNameController,
                        emailController: emailController,
                      ),
                      const SizedBox(height: 15),
                      const CountryStatesDropdowns(),
                      const SizedBox(height: 15),
                      labelCommon(ConstString.zipCode),
                      CustomInput(
                        controller: zipCodeController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter ZIP code';
                          }
                          return null;
                        },
                        hintText: ConstString.enterZip,
                        paddingHorizontal: 20,
                        textInputAction: TextInputAction.next,
                      ),
                      SignupPhonePass(
                        phoneController: phoneController,
                        passController: passwordController,
                        confirmPassController: confirmPasswordController,
                      ),
                      const SizedBox(height: 10),
                      Obx(() => Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: termsAgree.value,
                                  onChanged: (val) =>
                                      termsAgree.value = val ?? false,
                                  activeColor: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      termsAgree.value = !termsAgree.value,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'I agree with the ',
                                      style: const TextStyle(
                                          color: Color(0xff646464),
                                          fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: 'Terms & Conditions',
                                          style: const TextStyle(
                                              color: primaryColor),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Get.toNamed(AppRoutes.TERMS_AND_CONDITIONS);
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 15),
                      Obx(
                        () => buttonPrimary(
                          ConstString.signUp,
                          () {
                            if (authController.signupFormKey.currentState
                                    ?.validate() !=
                                true) {
                              return;
                            }
                            if (!termsAgree.value) {
                              Get.snackbar(
                                "Terms & Conditions",
                                "You must agree to the terms to continue",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            authController.signUp();
                          },
                          isloading: authController.isLoading.value,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "${ConstString.alreadyHaveAccount}  ",
                              style: const TextStyle(
                                  color: Color(0xff646464), fontSize: 14),
                              children: <TextSpan>[
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                    },
                                  text: ConstString.login,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
