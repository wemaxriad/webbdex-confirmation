import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Mock login state for demonstration
  var isLoggedIn = true.obs;

  // Profile details (using Rx for reactivity, allowing the view to update if these change)
  var name = 'Sharif Shakil'.obs;
  var phone = '+973 3300 0000'.obs;
  var email = 'sharif.shakil@example.com'.obs;
  var country = 'Bahrain'.obs;
  var memberSince = 'Jan 2024'.obs;
  var profileImage = 'assets/images/user.png'.obs; // Replace with your actual path

  @override
  void onInit() {
    // Check authentication status here if needed,
    // e.g., using a service or stored token.
    super.onInit();
  }

  Future<void> refreshProfile() async {
    // Simulate a network call to refresh data
    await Future.delayed(const Duration(seconds: 2));
    // In a real app, you would re-fetch user data here
    name.value = 'Sharif Shakil (Refreshed)';
    Get.snackbar('Success', 'Profile has been refreshed');
  }

  // Example function to switch to not logged in state
  void toggleLoginStatus() {
    isLoggedIn.value = !isLoggedIn.value;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
