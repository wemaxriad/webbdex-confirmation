import 'package:confirmation_agent_app/app/modules/auth/bindings/auth_binding.dart';
import 'package:confirmation_agent_app/app/modules/auth/reset_password/reset_password_binding.dart';
import 'package:confirmation_agent_app/app/modules/auth/reset_password/reset_password_view.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/signin_view.dart';
import 'package:confirmation_agent_app/app/modules/auth/views/signup_view.dart';
import 'package:confirmation_agent_app/app/modules/order/bindings/order_binding.dart';
import 'package:confirmation_agent_app/app/modules/order/view/order_view.dart';
import 'package:confirmation_agent_app/app/modules/privacyPolicy/binding/privacy_policy_binding.dart';
import 'package:confirmation_agent_app/app/modules/privacyPolicy/view/privacy_policy_view.dart';
import 'package:confirmation_agent_app/app/modules/profile/binding/edit_profile_binding.dart';
import 'package:confirmation_agent_app/app/modules/profile/view/edit_profile_view.dart';
import 'package:confirmation_agent_app/app/modules/termsandcondition/binding/terms_binding.dart';
import 'package:confirmation_agent_app/app/modules/termsandcondition/view/terms_view.dart';
import 'package:get/get.dart';

import '../SplashScreen/splash_screen.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashScreen(),
      binding: AuthBinding()
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () =>  DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNIN,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => SignupPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.ORDER,
      page: () => const MyOrdersView(),
      binding: MyOrdersBinding(),
    ),
    GetPage(
      name: AppRoutes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.TERMS_AND_CONDITIONS,
      page: () => const TermsView(),
      binding: TermsBinding(),
    ),
    GetPage(
      name: AppRoutes.PRIVACY_POLICY,
      page: () => PrivacyView(),
      binding: PrivacyBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    )
  ];
}
