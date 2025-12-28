import 'package:confirmation_agent_app/app/modules/auth/views/components/dropdowns/country_states_dropdowns.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/components/email_name_fields.dart';
import 'package:confirmation_agent_app/app/modules/profile/controller/edit_profile_controller.dart';
import 'package:confirmation_agent_app/app/utils/common_helper.dart';
import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/const_strings.dart';
import '../../../utils/custom_input.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(controller.profileController.profileImage.value),
                      )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        controller.changeProfileImage();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            EmailNameFields(
              fullNameController: controller.fullNameController,
              userNameController: controller.userNameController,
              emailController: controller.emailController,
            ),
            const SizedBox(height: 15),
            const CountryStatesDropdowns(),
            const SizedBox(height: 15),
            labelCommon(ConstString.zipCode),
            CustomInput(
              controller: controller.zipCodeController,
              hintText: ConstString.enterZip,
              paddingHorizontal: 20,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 15),
            labelCommon('Phone'),
            CustomInput(
              controller: controller.phoneController,
              hintText: 'Enter phone number',
              isNumberField: true,
              paddingHorizontal: 17,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 30),
            buttonPrimary(
              'Update Profile',
              () {
                controller.updateProfile();
              },
            ),
          ],
        ),
      ),
    );
  }
}
