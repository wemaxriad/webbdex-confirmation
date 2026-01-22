import 'package:confirmation_agent_app/app/utils/app_translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/globalController/global_controller.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController(), permanent: true);
  Get.put(GlobalController(), permanent: true);

 var  prefs = await SharedPreferences.getInstance();
 var lanKey = prefs.getString('langKey');
  if (lanKey != null) {
     Get.updateLocale(Locale(lanKey));
  } else {
    Get.updateLocale(Locale('en'));
  }
  Get.find<GlobalController>().selectedLang.value = prefs.getString('langKey') ?? 'en';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Confirmation Agent',

      // ======== THEME SETTINGS =========
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xffF5F5F5),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      // ======== NAVIGATION =========
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      // Removed the manual Directionality builder.
      // GetMaterialApp handles RTL automatically based on the Locale now.
    );
  }
}