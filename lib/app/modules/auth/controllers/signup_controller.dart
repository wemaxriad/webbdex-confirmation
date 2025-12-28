import 'package:get/get.dart';

class SignUpController extends GetxController {
  // Dummy data for countries
  final List<String> countries = [
    'USA',
    'Canada',
    'UK',
    'Bahrain',
  ];

  // Dummy data for states based on country
  final Map<String, List<String>> states = {
    'USA': ['California', 'Texas', 'Florida'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia'],
    'UK': ['England', 'Scotland', 'Wales'],
    'Bahrain': ['Manama', 'Muharraq', 'Riffa'],
  };

  // Dummy data for cities based on state
  final Map<String, List<String>> cities = {
    'California': ['Los Angeles', 'San Francisco', 'San Diego'],
    'Texas': ['Houston', 'Austin', 'Dallas'],
    'Florida': ['Miami', 'Orlando', 'Tampa'],
    'Ontario': ['Toronto', 'Ottawa', 'Hamilton'],
    'Quebec': ['Montreal', 'Quebec City', 'Gatineau'],
    'British Columbia': ['Vancouver', 'Victoria', 'Kelowna'],
    'England': ['London', 'Manchester', 'Birmingham'],
    'Scotland': ['Glasgow', 'Edinburgh', 'Aberdeen'],
    'Wales': ['Cardiff', 'Swansea', 'Newport'],
    'Manama': ['Manama City'],
    'Muharraq': ['Muharraq City'],
    'Riffa': ['Riffa City'],
  };

  // Observables for selected country, state and city
  final Rx<String?> selectedCountry = Rx<String?>(null);
  final Rx<String?> selectedState = Rx<String?>(null);
  final Rx<String?> selectedCity = Rx<String?>(null);

  final RxList<String> availableStates = <String>[].obs;
  final RxList<String> availableCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // When the selected country changes, update the list of available states
    ever(selectedCountry, (String? country) {
      selectedState.value = null; // Reset state selection
      availableStates.clear();
      if (country != null) {
        availableStates.value = states[country] ?? [];
      }
    });

    // When the selected state changes, update the list of available cities
    ever(selectedState, (String? state) {
      selectedCity.value = null; // Reset city selection
      availableCities.clear();
      if (state != null) {
        availableCities.value = cities[state] ?? [];
      }
    });
  }
}
