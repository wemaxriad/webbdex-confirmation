import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/common_helper.dart';
import '../../../../utils/const_strings.dart';
import '../../../../utils/constant_colors.dart';
import '../../../../utils/constant_styles.dart';
import '../../../../utils/custom_input.dart';
import '../../controllers/auth_controller.dart';

class EmailNameFields extends StatelessWidget {
  EmailNameFields({
    Key? key,
    required this.fullNameController,
    required this.userNameController,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController fullNameController;
  final TextEditingController userNameController;
  final TextEditingController emailController;

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // For translation, you might replace this with your own translation logic
    String tr(String key) => key; // Replace with your translation call if needed

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name
        labelCommon(tr(ConstString.fullName)),
        CustomInput(
          controller: fullNameController,
          paddingHorizontal: 20,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return tr(ConstString.plzEnterFullName);
            }
            return null;
          },
          hintText: tr(ConstString.enterFullName),
          textInputAction: TextInputAction.next,
        ),

        // User Name
        labelCommon(tr(ConstString.userName)),
        CustomInput(
          controller: userNameController,
          paddingHorizontal: 20,
          marginBottom: 5,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return tr(ConstString.plzEnterUsername);
            }
            return null;
          },
          hintText: tr(ConstString.enterUsername),
          textInputAction: TextInputAction.next,
          onChanged: (v) {
            // Call your controller method to check username availability
           // _authController.checkUsername(v, context);
          },
        ),

        // Obx(() {
        //   // Show username status message reactively
        //   // if (_authController.usernameData.value.isNotEmpty) {
        //   //   return paragraphCommon(_authController.usernameData.value, color: successColor);
        //   // } else {
        //   //   return const SizedBox.shrink();
        //   // }
        // }),

        //gapH(16),

        // Email
        labelCommon(tr(ConstString.email)),
        CustomInput(
          controller: emailController,
          paddingHorizontal: 20,
          validation: (value) {
            if (value == null || value.isEmpty) {
              return tr(ConstString.plzEnterYourEmail);
            }
            return null;
          },
          hintText: tr(ConstString.enterEmail),
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }
}
