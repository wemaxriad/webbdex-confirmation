import 'package:confirmation_agent_app/app/modules/auth/reset_password/reset_password_controller.dart';
import 'package:confirmation_agent_app/app/utils/common_helper.dart';
import 'package:confirmation_agent_app/app/utils/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller = Get.put(ResetPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Obx(() {
          switch (controller.currentStep.value) {
            case ResetPasswordStep.EMAIL:
              return _buildEmailStep(controller);
            case ResetPasswordStep.OTP:
              return _buildOtpStep(controller);
            case ResetPasswordStep.CHANGE_PASSWORD:
              return _buildChangePasswordStep(controller);
            default:
              return Container();
          }
        }),
      ),
    );
  }

  Widget _buildEmailStep(ResetPasswordController controller) {
    return Form(
      key: controller.emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelCommon('Email'),
          CustomInput(
            controller: controller.emailController,
            hintText: 'Enter your email',
            validation: (value) {
              if (value == null || value.isEmpty || !GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Obx(() => buttonPrimary(
                'Send OTP',
                () {
                  controller.sendOtp();
                },
                isloading: controller.isLoading.value,
              )),
        ],
      ),
    );
  }

  Widget _buildOtpStep(ResetPasswordController controller) {
    return Form(
      key: controller.otpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelCommon('OTP'),
          CustomInput(
            controller: controller.otpController,
            hintText: 'Enter OTP',
            validation: (value) {
              if (value == null || value.isEmpty || value.length != 4) {
                return 'Please enter a 4-digit OTP';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Obx(() => buttonPrimary(
                'Verify OTP',
                () {
                  controller.verifyOtp();
                },
                isloading: controller.isLoading.value,
              )),
        ],
      ),
    );
  }

  Widget _buildChangePasswordStep(ResetPasswordController controller) {
    return Form(
      key: controller.passwordFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelCommon('New Password'),
          CustomInput(
            controller: controller.newPasswordController,
            hintText: 'Enter new password',
            isPasswordField: true,
            validation: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          labelCommon('Confirm New Password'),
          CustomInput(
            controller: controller.confirmPasswordController,
            hintText: 'Confirm new password',
            isPasswordField: true,
            validation: (value) {
              if (value != controller.newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          Obx(() => buttonPrimary(
                'Change Password',
                () {
                  controller.changePassword();
                },
                isloading: controller.isLoading.value,
              )),
        ],
      ),
    );
  }
}
