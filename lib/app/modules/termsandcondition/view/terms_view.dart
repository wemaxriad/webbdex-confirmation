import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// *** CHANGE: Use the official Flutter Markdown package ***
import 'package:flutter_markdown/flutter_markdown.dart';
import '../controller/terms_controller.dart';

//const Color kPrimaryColor = Color(0xffFF3B30);

class TermsView extends GetView<TermsController> {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Terms & Conditions", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        // *** CHANGE: Use the standard Markdown widget ***
        return Markdown(
          data: controller.termsText.value,
          padding: const EdgeInsets.all(16.0),

          // Style customization uses a MarkdownStyleSheet object
          styleSheet: MarkdownStyleSheet(
            h1: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              height: 2,
            ),
            h2: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 2,
            ),
            p: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5,
            ),
            strong: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        );
      }),
    );
  }
}