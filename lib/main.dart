// import 'package:confirmation_agent_app/app/utils/app_translation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'app/routes/app_pages.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       translations: AppTranslation(),
//       locale: const Locale('en'),
//       fallbackLocale: const Locale('en'),
//       supportedLocales: const [
//         Locale('en'),
//         Locale('ar'),
//       ],
//       builder: (context, child) {
//         return Directionality(
//             textDirection:
//             Get.locale?.languageCode == 'ar'
//             ?TextDirection.rtl
//             :TextDirection.ltr,
//             child: child!,
//         );
//       },
//       debugShowCheckedModeBanner: false,
//       title: 'Confirmation Agent',
//
//       // ======== YOUR LIGHT WHITE THEME =========
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(0xffF5F5F5), // light grey background
//
//         // Deep white AppBar
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 1,
//           centerTitle: true,
//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//
//         // Deep white bottom navigation
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Colors.white,
//           selectedItemColor: Colors.red,
//           unselectedItemColor: Colors.grey,
//           elevation: 10,
//           type: BottomNavigationBarType.fixed,
//         ),
//
//         useMaterial3: true,
//       ),
//
//       // ======== ROUTES =========
//       initialRoute: AppPages.INITIAL,
//       getPages: AppPages.routes,
//     );
//   }
// }

import 'package:confirmation_agent_app/app/utils/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import this
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Localization Settings
      translations: AppTranslation(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),

      // These delegates provide the actual translations for Material widgets
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // List all supported locales
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

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