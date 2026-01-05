import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/view/confirmation_agent_documents_view.dart';

enum ConfirmationStatus { pending, approved, rejected }

class DocumentStatusCard extends StatelessWidget {
  final bool isSubmitted;
  final int status;

  const DocumentStatusCard({
    super.key,
    required this.isSubmitted,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSubmitted) {
      // ❌ Documents not submitted
      return Card(
        color: Colors.orange[50],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "📄 Documents Required",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "You have successfully registered and logged in, but you have not submitted your required documents yet. "
                    "You will not be able to work until your documents are submitted.",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.to(
                        () => const ConfirmationAgentDocumentsView(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  // Navigate to documents upload page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                child: const Text("Upload Documents Now", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      );
    } else if (isSubmitted && status != 3) {
      // ⏳ Documents under review OR ❌ Rejected
      final isRejected = status == 4;
      return Card(
        color: isRejected ? Colors.red[50] : Colors.blue[50],
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRejected ? "❌ Documents Rejected" : "⏳ Documents Under Review",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isRejected ? Colors.red : Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your documents have been submitted and are currently under review. "
                    "You will be able to access all features once your documents are approved.",
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              if (isRejected) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "❌ Your last submission was rejected. Please re-submit your valid documents.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),


              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.to(
                        () => const ConfirmationAgentDocumentsView(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                child: const Text("Re-submit Documents", style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ If approved or nothing to show
    return const SizedBox.shrink();
  }
}
