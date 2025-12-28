import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class TermsController extends GetxController {
  // Observable to track loading state
  var isLoading = true.obs;

  // Observable to hold the fetched terms and conditions text
  var termsText = ''.obs;

  @override
  void onInit() {
    fetchTermsAndConditions();
    super.onInit();
  }

  // Function to simulate fetching T&C from an external source (API/Asset)
  void fetchTermsAndConditions() async {
    try {
      isLoading(true);

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock Data (Replace this with your actual API call)
      const mockTerms = """
        ## 1. Acceptance of Terms

        By accessing and using this application, you accept and agree to be bound by the terms and provisions of this agreement.

        ## 2. Services Provided

        This application provides a platform for managing your business orders and balances, as described in the user manual. We reserve the right to modify or discontinue any service with or without notice to you.

        ## 3. User Obligations

        You agree not to use the service for any illegal or unauthorized purpose. You must comply with all local laws regarding online conduct and acceptable content.

        ## 4. Limitation of Liability

        The service is provided on an "as is" and "as available" basis. The Company shall not be liable for any direct, indirect, incidental, special, consequential or exemplary damages.

        ## 5. Changes to Terms

        We reserve the right to revise these Terms and Conditions at any time. Your continued use of the application following any changes constitutes your acceptance of those changes.

        ## Effective Date: 15/12/2025
      """;

      termsText.value = mockTerms;

    } catch (e) {
      debugPrint("Error fetching terms: $e");
      termsText.value = "Failed to load terms and conditions. Please check your connection.";
    } finally {
      isLoading(false);
    }
  }
}