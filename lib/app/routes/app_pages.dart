import 'package:get/get.dart';
import 'package:i_carry/app/modules/carrier_management/binding/add_carrier_binding.dart';
import 'package:i_carry/app/modules/carrier_management/binding/carrier_management_binding.dart';
import 'package:i_carry/app/modules/carrier_management/view/add_carrier.dart';
import 'package:i_carry/app/modules/carrier_management/view/carrier_management_view.dart';
import 'package:i_carry/app/modules/warehouse/binding/warehouse_binding.dart';
import 'package:i_carry/app/modules/warehouse/view/warehouse_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/view/login_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/view/registration_view.dart';
import '../modules/shipments/add_recipients/bindings/recipients_binding.dart';
import '../modules/shipments/add_recipients/view/add_recipient_view.dart';
import '../modules/shipments/add_shipment/binding/location_binding.dart';
import '../modules/shipments/add_shipment/binding/shipment_details_binding.dart';
import '../modules/shipments/add_shipment/view/location_view.dart';
import '../modules/shipments/add_shipment/view/shipment_details_view.dart';
import '../modules/shipments/add_warehouse/bindings/add_warehouse_binding.dart';
import '../modules/shipments/add_warehouse/view/add_warehouse_view.dart';
import '../modules/shipments/binding/shipment_binding.dart';
import '../modules/shipments/shipment_submit/bindings/create_shipment_binding.dart';
import '../modules/shipments/shipment_submit/views/create_shipment_view.dart';
import '../modules/shipments/view/shipment_view.dart';
import '../modules/returns/bindings/returns_binding.dart';
import '../modules/returns/views/returns_view.dart';
import '../modules/failed_requests/bindings/failed_requests_binding.dart';
import '../modules/failed_requests/views/failed_requests_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/payments/bindings/payments_binding.dart';
import '../modules/payments/views/payments_view.dart';
import '../modules/shipping_calculator/bindings/shipping_calculator_binding.dart';
import '../modules/shipping_calculator/views/shipping_calculator_view.dart';
import '../modules/manage_team/bindings/manage_team_binding.dart';
import '../modules/manage_team/views/manage_team_view.dart';
import '../modules/company_profile/bindings/company_profile_binding.dart';
import '../modules/company_profile/views/company_profile_view.dart';
import '../modules/language/bindings/language_binding.dart';
import '../modules/language/views/language_view.dart';
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';
import '../modules/splash/view/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),

    GetPage(
      name: Routes.SHIPMENTS,
      page: () => const ShipmentsView(),
      binding: ShipmentsBinding(),
    ),

    GetPage(
      name: Routes.LOCATION,
      page: () => const LocationView(),
      binding: LocationBinding(),
    ),

    GetPage(
      name: Routes.SHIPMENT_DETAILS,
      page: () => const ShipmentDetailsView(),
      binding: ShipmentDetailsBinding(),
    ),

        GetPage(
      name: Routes.ADD_WAREHOUSE,
      page: () => const AddWarehouseView(),
      binding: AddWarehouseBinding(),
    ),

    GetPage(
      name: Routes.RETURNS,
      page: () => ReturnsView(),
      binding: ReturnsBinding(),
    ),

    GetPage(
      name: Routes.FAILED_REQUESTS,
      page: () => const FailedRequestsView(),
      binding: FailedRequestsBinding(),
    ),

    GetPage(
      name: Routes.WAREHOUSES,
      page: () => const WarehouseView(),
      binding: WarehouseBinding(),
    ),

    GetPage(
      name: Routes.RECIPIENTS,
      page: () => const AddRecipientView(),
      binding: RecipientsBinding(),
    ),

    GetPage(
      name: Routes.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),

    GetPage(
      name: Routes.PAYMENTS,
      page: () => const PaymentsView(),
      binding: PaymentsBinding(),
    ),

    GetPage(
      name: Routes.SHIPPING_CALCULATOR,
      page: () => const ShippingCalculatorView(),
      binding: ShippingCalculatorBinding(),
    ),


    GetPage(
      name: Routes.CARRIERS,
      page: () => const CarrierManagementView(),
      binding: CarrierManagementBinding(),
    ),
     GetPage(
      name: Routes.CREATE_SHIPMENT,
      page: () => const CreateShipmentView(),
      binding: CreateShipmentBinding(),
    ),


    GetPage(
      name: Routes.MANAGE_TEAM,
      page: () => const ManageTeamView(),
      binding: ManageTeamBinding(),
    ),

    GetPage(
      name: Routes.COMPANY_PROFILE,
      page: () => const CompanyProfileView(),
      binding: CompanyProfileBinding(),
    ),

    GetPage(
      name: Routes.LANGUAGE,
      page: () => const LanguageView(),
      binding: LanguageBinding(),
    ),

    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),
     GetPage(
      name: Routes.ADD_CARRIER,
      page: () => const AddCarrierView(),
      binding: AddCarrierBinding(),
    ),
  ];
}
