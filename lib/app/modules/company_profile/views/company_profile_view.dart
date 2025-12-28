import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/company_profile_controller.dart';

class CompanyProfileView extends StatelessWidget {
  const CompanyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CompanyProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Company Profile"),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              _inputField("Company Name", controller.companyName),
              _inputField("Company Email", controller.companyEmail,
                  keyboard: TextInputType.emailAddress),
              _inputField("Phone Number", controller.phone,
                  keyboard: TextInputType.phone),
              _inputField("Address", controller.address, maxLines: 2),
              _inputField("Website", controller.website,
                  keyboard: TextInputType.url),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.saveProfile,
                  child: const Text("Save Changes",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
