import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/auth/model/LanguagesModel.dart';
import '../services/api-list.dart';
import '../services/server.dart';
import '../services/user-service.dart';

class GlobalController extends GetxController {

  Server server = Server();
  UserService userService = UserService();
  var businessName = 'Confirmation App'.obs;
  var userImage = 'assets/images/user.png'.obs;

  RxList<String> countries = <String>[].obs;
  RxList<Languages> languagesList = <Languages>[].obs;
  RxMap<String, Map<String, dynamic>> translations =
      <String, Map<String, dynamic>>{}.obs;
  /// selected value
  RxnString selectedCountry = RxnString();
  RxString selectedLang = 'en'.obs;


  @override
  void onInit() {

    getLanguagesList();
    getLanguagesFileList();
    // TODO: implement onInit
    super.onInit();

  }



  Future<void> getLanguagesList() async {
    final response = await server.getRequest(
      endPoint: ApiList.languagesList!,
    );

    if (response == null) {
      debugPrint("API response is null");
      return;
    }

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        final countryModel = LanguagesModel.fromJson(jsonResponse);
        languagesList.value = <Languages>[].obs;
        languagesList.assignAll(countryModel.languages!);

        if (languagesList.isNotEmpty) {
          selectedCountry.value = '';
        }
      } catch (e) {
        debugPrint("JSON parse error: $e");
      }
    } else {
      debugPrint("API failed: ${response.statusCode}");
    }
  }

  Future<void> getLanguagesFileList() async {
    final response = await server.getRequest(
      endPoint: ApiList.languagesFileList!,
    );

    if (response == null) {
      debugPrint("API response is null");
      return;
    }

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        print('===================================>');
        print(jsonResponse);
        final Map<String, dynamic> rawTranslations =
        Map<String, dynamic>.from(jsonResponse['translations']);

        translations.value = rawTranslations.map(
              (key, value) => MapEntry(
            key.toString(),
            Map<String, dynamic>.from(value as Map),
          ),
        );

      } catch (e) {
        debugPrint("JSON parse error: $e");
      }
    } else {
      debugPrint("API failed: ${response.statusCode}");
    }
  }

  String t(String key) {

    final lang = Get.locale?.languageCode ?? 'en';
    return translations[lang]?[key] ?? key;
  }

  String getLangIcon(String slug) {
    print(slug);
    final Map<String, String> flags = {
      // English
      'en': '🇬🇧',
      'en_GB': '🇬🇧',
      'en_US': '🇺🇸',
      'en_AU': '🇦🇺',
      'en_CA': '🇨🇦',

      // Bangla
      'bn': '🇧🇩',
      'bn_BD': '🇧🇩',
      'bn_IN': '🇮🇳',

      // Arabic
      'ar': '🇸🇦',
      'ar_SA': '🇸🇦',
      'ar_AE': '🇦🇪',
      'ar_EG': '🇪🇬',

      // Hindi / Urdu
      'hi': '🇮🇳',
      'ur': '🇵🇰',

      // Turkish
      'tr': '🇹🇷',
      'tr_TR': '🇹🇷',

      // Italian
      'it': '🇮🇹',
      'it_IT': '🇮🇹',

      // Swahili
      'sw': '🇰🇪', // Common default (Kenya)
      'sw_KE': '🇰🇪',
      'sw_TZ': '🇹🇿',

      // French
      'fr': '🇫🇷',
      'fr_FR': '🇫🇷',
      'fr_CA': '🇨🇦',

      // European
      'fr': '🇫🇷',
      'de': '🇩🇪',
      'es': '🇪🇸',
      'it': '🇮🇹',
      'pt': '🇵🇹',
      'pt_BR': '🇧🇷',
      'ru': '🇷🇺',

      // Asian
      'zh': '🇨🇳',
      'zh_CN': '🇨🇳',
      'zh_TW': '🇹🇼',
      'ja': '🇯🇵',
      'ko': '🇰🇷',
      'th': '🇹🇭',
      'vi': '🇻🇳',
      'id': '🇮🇩',
      'ms': '🇲🇾',

      // Others
      'tr': '🇹🇷',
      'fa': '🇮🇷',
      'nl': '🇳🇱',
      'sv': '🇸🇪',
      'no': '🇳🇴',
      'da': '🇩🇰',
    };

    return flags[slug] ?? '🌐';
  }


}