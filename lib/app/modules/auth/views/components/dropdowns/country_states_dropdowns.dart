import 'package:confirmation_agent_app/app/modules/auth/views/components/dropdowns/city_dropdown.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/components/dropdowns/country_dropdown.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/components/dropdowns/state_dropdown.dart';
import 'package:confirmation_agent_app/app/utils/common_helper.dart';
import 'package:confirmation_agent_app/app/utils/const_strings.dart';
import 'package:flutter/material.dart';

class CountryStatesDropdowns extends StatelessWidget {
  const CountryStatesDropdowns({super.key, this.isFromDeliveryPage = false});

  final bool isFromDeliveryPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country dropdown ===============>
        labelCommon(ConstString.chooseCountry),
        CountryDropdown(
          isFromDeliveryPage: isFromDeliveryPage,
        ),
        const SizedBox(
          height: 25,
        ),
        // States dropdown ===============>
        labelCommon(ConstString.chooseStates),
        StateDropdown(
          isFromDeliveryPage: isFromDeliveryPage,
        ),
        const SizedBox(
          height: 25,
        ),
        // city dropdown ===============>
        labelCommon(ConstString.chooseCity),
        CityDropdown(
          isFromDeliveryPage: isFromDeliveryPage,
        ),
      ],
    );
  }
}
