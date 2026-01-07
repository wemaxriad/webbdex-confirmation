
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../services/api-list.dart';
import '../../../services/server.dart';
import '../../../services/user-service.dart';
import '../model/CountryModel.dart';
import '../model/LoginModel.dart';

class AuthController extends GetxController {

  Server server = Server();
  UserService userService = UserService();

  // Form keys for login and signup
  final formKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();

  // TextFields controllers for login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // TextFields controllers for signup
  final signupEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  RxList<String> countries = <String>[].obs;
  /// selected value
  RxnString selectedCountry = RxnString();

  // Reactive states
  var isLoading = false.obs;
  var passwordVisible = false.obs;
  var keepLoggedIn = true.obs;
  var termsAgree = false.obs;
  RxBool isUser = false.obs;

  @override
  void onInit() {
    getCountryList();
    _initToken();
    // TODO: implement onInit
    super.onInit();

  }

  Future<void> _initToken() async {
    final token = await userService.getToken();
    Server.initToken(token: token.toString());
  }

  // ------------------------- LOGIN -------------------------
  void signIn() async {
    if (!formKey.currentState!.validate()) {
      return; // Form validation failed
    }

    isLoading(true);

    Map body = {'username': emailController.text, 'password': passwordController.text};
    String jsonBody = json.encode(body);
    server.postRequest(endPoint: ApiList.login, body: jsonBody).then((response) {
      if (response != null && response.statusCode == 200) {

        final jsonResponse = json.decode(response.body);
        var loginData = LoginModel.fromJson(jsonResponse);
        var bearerToken = 'Bearer ' + "${loginData.token}";
        userService.saveBoolean(key: 'is-user', value: true);
        userService.saveString(key: 'token', value: loginData.token);
        userService.saveString(key: 'userID', value: loginData.users?.id.toString());
        isUser.value = true;

        Server.initToken(token: bearerToken);
        emailController.clear();
        passwordController.clear();
        isLoading(false);
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        Get.offAllNamed(AppRoutes.DASHBOARD);
        Get.rawSnackbar(message: "Logged in successfully", backgroundColor: Colors.green, snackPosition: SnackPosition.TOP);
      } else {
        isLoading(false);
        final jsonResponse = json.decode(response.body);
        Get.rawSnackbar(message: "${jsonResponse['message']}", backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      }
    });
  }

  // ------------------------- SIGNUP -------------------------
  void signUp() async {
    if (!signupFormKey.currentState!.validate()) {
      return; // Form validation failed
    }

    isLoading(true);

    Map body = {
      'name': fullNameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'username': userNameController.text,
      'password': passwordController.text,
      'password_confirmation': confirmPasswordController.text,
      'country': selectedCountry.value,
      'terms_condition': '1',
    };
    String jsonBody = json.encode(body);
    server.postRequest(endPoint: ApiList.registerUser, body: jsonBody).then((response) {
      if (response != null && response.statusCode == 200) {

        final jsonResponse = json.decode(response.body);
        var loginData = LoginModel.fromJson(jsonResponse);
        var bearerToken = 'Bearer ' + "${loginData.token}";
        userService.saveBoolean(key: 'is-user', value: true);
        userService.saveString(key: 'token', value: loginData.token);
        userService.saveString(key: 'userID', value: loginData.users?.id.toString());
        isUser.value = true;

        Server.initToken(token: bearerToken);
        emailController.clear();
        passwordController.clear();
        isLoading(false);
        Future.delayed(const Duration(milliseconds: 10), () {
          update();
        });
        Get.offAllNamed(AppRoutes.DASHBOARD);
        Get.rawSnackbar(message: "Account created & Logged in successfully", backgroundColor: Colors.green, snackPosition: SnackPosition.TOP);
      } else {
        isLoading(false);
        final jsonResponse = json.decode(response.body);
        Get.rawSnackbar(message: "${jsonResponse['message']}", backgroundColor: Colors.red, snackPosition: SnackPosition.TOP);
      }
    });
  }

  // Toggle password visibility in both login and signup (if needed)
  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  // You may want to add toggle for termsAgree from UI too
  void toggleTermsAgree(bool? value) {
    if (value != null) termsAgree.value = value;
  }

  @override
  void onClose() {
    // Dispose all controllers
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    userNameController.dispose();
    signupEmailController.dispose();
    phoneController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  initAuthCheck() async {
    isUser.value = await userService.loginCheck();
  }




  refreshToken() async {
    server.getRequestToken(endPoint: ApiList.refreshToken!).then((response) {
      print(response);
      if (response != null && response.statusCode == 200) {
        try {
          final jsonResponse = json.decode(response.body);
          var refreshData = LoginModel.fromJson(jsonResponse);
          print(refreshData);

          var newToken = 'Bearer ' + "${refreshData.token}";
          isUser.value = true;
          userService.saveBoolean(key: 'is-user', value: true);
          userService.saveString(key: 'token', value: refreshData.token);
          userService.saveString(key: 'userID', value: refreshData.users!.id.toString());
          Server.initToken(token: newToken);
          Get.offNamed(AppRoutes.DASHBOARD);
          return true;
        } catch (e) {
          userLogout();
        }
      } else {
        userLogout();
        return false;
      }
    });
  }

  /// API call
  Future<void> getCountryList() async {
    final response = await server.getRequest(
      endPoint: ApiList.countryList!,
    );

    if (response == null) {
      debugPrint("API response is null");
      return;
    }

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        final countryModel = CountryModel.fromJson(jsonResponse);

        countries.assignAll(countryModel.countries!);

        if (countries.isNotEmpty) {
          selectedCountry.value = countries.first;
        }
      } catch (e) {
        debugPrint("JSON parse error: $e");
      }
    } else {
      debugPrint("API failed: ${response.statusCode}");
    }
  }

  userLogout() async {
    await userService.removeSharedPreferenceData();
    isUser.value = false;
    Get.offNamed(AppRoutes.SIGNIN);
  }

  deleteAccount() async {
    try {
      var response = await server.deleteRequest(endPoint: ApiList.deleteAccount);
      print(response.statusCode);
      if (response != null && response.statusCode == 200) {
        Get.offNamed(AppRoutes.SIGNIN);
      }
    } catch (e) {
      print(e);
    }
  }

}

