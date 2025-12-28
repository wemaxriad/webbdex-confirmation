import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/common_helper.dart';
import '../../../../utils/const_strings.dart';
import '../../../../utils/custom_input.dart';

class SignupPhonePass extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passController;
  final TextEditingController confirmPassController;

  // Reactive variables for password visibility
  final RxBool newPasswordVisible = false.obs;
  final RxBool confirmPasswordVisible = false.obs;

  SignupPhonePass({
    Key? key,
    required this.phoneController,
    required this.passController,
    required this.confirmPassController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      // You can add your formKey here if needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone number field
          labelCommon(ConstString.phone),
          CustomInput(
            controller: phoneController,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
            hintText: ConstString.enterPhoneNumber,
            isNumberField: true,
            paddingHorizontal: 17,
            textInputAction: TextInputAction.next,
          ),

          // Password label
          labelCommon(ConstString.pass),
          CustomInput(
            controller: passController,
            hintText: ConstString.enterPass,
            isPasswordField: true,
            validation: (value) =>
                value == null || value.isEmpty ? "Please enter password" : null,
          ),

          const SizedBox(height: 5),

          // Confirm Password label
          labelCommon(ConstString.confirmPass),
          CustomInput(
            controller: confirmPassController,
            hintText: ConstString.retypePass,
            isPasswordField: true,
            validation: (value) {
              if (value == null || value.isEmpty) {
                return "Please re-type password";
              }
              if (passController.text != value) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
