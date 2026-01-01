import 'package:confirmation_agent_app/app/utils/const_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';

class CountryDropdown extends StatelessWidget {
  const CountryDropdown({Key? key, this.isFromDeliveryPage = false})
      : super(key: key);

  final bool isFromDeliveryPage;

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Obx(() {
      if (controller.countries.isEmpty) {
        return const CircularProgressIndicator();
      }

      return DropdownButtonFormField<String>(
        value: controller.selectedCountry.value,
        items: controller.countries.map((country) {
          return DropdownMenuItem<String>(
            value: country,
            child: Text(country),
          );
        }).toList(),
        onChanged: (value) {
          controller.selectedCountry.value = value;
        },
        decoration: InputDecoration(
          hintText: ConstString.chooseCountry,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        isExpanded: true,
      );
    });
  }
}

