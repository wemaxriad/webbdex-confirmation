import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class PrivacyController extends GetxController {
  var isLoading = true.obs;

  // Observable to hold the fetched policy text
  var policyText = ''.obs;

  @override
  void onInit() {
    fetchPrivacyPolicy();
    super.onInit();
  }

  // Function to simulate fetching the policy from an external source (API/Asset)
  void fetchPrivacyPolicy() async {
    try {
      isLoading(true);

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock Data (Replace this with your actual policy)
      const mockPolicy = """
        # Privacy Policy

        ## 1. Information We Collect

        We collect information to provide better services to all our users. This includes:

        * **Personal Identification Information:** Name, email address, and phone number, provided when you create an account.
        * **Transaction Data:** Details about orders, amounts, and payment statuses.
        
        ## 2. How We Use Your Information

        We use the information we collect to:

        * Provide, maintain, and improve our services.
        * Process transactions and send related information.
        * Send technical notices, updates, security alerts, and support messages.

        ## 3. Data Security

        We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure. However, no internet transmission is entirely secure.

        ## 4. Third-Party Sharing

        We do not share your personal information with third parties except as necessary to process payments or comply with legal requirements.

        ---

        ## Last Updated: 15/12/2025
      """;

      policyText.value = mockPolicy;

    } catch (e) {
      debugPrint("Error fetching policy: $e");
      policyText.value = "Failed to load the Privacy Policy. Please check your connection.";
    } finally {
      isLoading(false);
    }
  }
}