// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/language_controller.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Language"),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          children: [
            LanguageItem(
              label: "English",
              selected: controller.selectedLanguage.value == 0,
              onTap: () => controller.changeLanguage(0),
            ),
            const SizedBox(height: 10),
            LanguageItem(
              label: "العربية",
              selected: controller.selectedLanguage.value == 1,
              onTap: () => controller.changeLanguage(1),
            ),
          ],
        )),
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const LanguageItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: selected ? Colors.blue.shade100 : Colors.grey.shade200,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : const Icon(Icons.circle_outlined),
      onTap: onTap,
    );
  }
}
