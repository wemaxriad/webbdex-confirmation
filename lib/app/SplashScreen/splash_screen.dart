import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../routes/app_routes.dart';
import '../utils/constant_colors.dart';
import '../utils/others_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController authController = AuthController();

  @override
  void initState() {
    authController.initAuthCheck();
    Timer(
      const Duration(seconds: 2),
      () {
        logInCheck();
      },
    );
    super.initState();
  }

  // update(String token) async {
  //   SharedPreferences storage = await SharedPreferences.getInstance();
  //   await storage.setString('deviceToken', token);
  //   print('fcm token===========>');
  //   print(token);
  // }


  logInCheck() async {
    if (authController.isUser.isTrue) {
      // authController.refreshToken();
      Get.offNamed(AppRoutes.DASHBOARD);
    } else {
      Get.offNamed(AppRoutes.SIGNIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 95,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight)),
              ),
              const SizedBox(
                height: 15,
              ),
              showLoading(primaryColor)
            ],
          ),
        ));
  }
}
