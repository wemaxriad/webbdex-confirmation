import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/language/controller/language_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/shipment_data_service.dart';

// This binding is used to initialize global services and controllers
// that need to be available as soon as the app starts.
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Use permanent: true to ensure the controller is not disposed of
    // when routes are changed.
    Get.put(LanguageController(), permanent: true);
    Get.put(ShipmentDataService(), permanent: true);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GetMaterialApp(
      title: "iCarry",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // Use initialBinding to load critical services at startup.
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
