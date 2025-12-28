import 'dart:ui';

import 'package:get/get.dart';

class LanguageController extends GetxController {
  // 0 = English, 1 = Arabic
  RxInt selectedLanguage = 0.obs;

  void changeLanguage(int index) {
    selectedLanguage.value = index;

    if (index == 0) {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'SA'));
    }
  }
}
