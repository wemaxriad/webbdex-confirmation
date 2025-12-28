import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/modules/registration/controller/registration_controller.dart';
import '../../../utils/constants/colors.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(controller.firstNameController, 'First Name'),
            const SizedBox(height: 16),
            _buildTextField(controller.lastNameController, 'Last Name'),
            const SizedBox(height: 16),
            _buildTextField(controller.emailController, 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField(controller.phoneController, 'Phone Number', keyboardType: TextInputType.phone),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _buildTextField(controller.companyNameController, 'Company Name'),
            const SizedBox(height: 16),
            _buildTextField(controller.companyEmailController, 'Company Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildIndustryDropdown(),
            Obx(() {
              if (controller.showNewIndustryField.value) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: _buildTextField(controller.newIndustryController, 'Please specify your industry'),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            _buildTextField(controller.passwordController, 'Password', obscureText: true),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.register,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColor.primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildIndustryDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
      value: controller.selectedIndustry.value,
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.selectedIndustry.value = newValue;
        }
      },
      items: controller.industryOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Industry',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ));
  }
}
