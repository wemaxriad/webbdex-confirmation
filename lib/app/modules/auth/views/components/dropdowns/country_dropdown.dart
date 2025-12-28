import 'package:confirmation_agent_app/app/modules/auth/controllers/signup_controller.dart';
import 'package:confirmation_agent_app/app/utils/const_strings.dart';
import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({Key? key, this.isFromDeliveryPage = false})
      : super(key: key);

  final bool isFromDeliveryPage;

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find<SignUpController>();

    return Obx(() => DropdownButtonFormField<String>(
          value: signUpController.selectedCountry.value,
          items: signUpController.countries.map((String country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: (newValue) {
            signUpController.selectedCountry.value = newValue;
          },
          decoration: InputDecoration(
            hintText: ConstString.chooseCountry,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: greyFive),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: greyFive),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: primaryColor),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
          isExpanded: true,
        ));
  }
}
