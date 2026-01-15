class ApiList {
  // static String? mainUrl = "http://192.168.0.107/webbydex/";
  static String? mainUrl = "https://webbydex.com/";
  static String? apiUrl = "webbydex.com";
  static String? mapGoogleApiKey = "";
  static String? autoUpdate = "on";
  static String? apiVersion         = "v1";// api version
  static String? authentication     = "";
  static String? apiCheckKey     = "";
  static String? server = "${mainUrl}api/v1";
  static String? apiEndPoint = "api/v10/";
  static String? login = "${server!}/confirmation-agent/login";
  static String? registerUser = "${server!}/confirmation-agent/register";
  static String? countryList = "${server!}/confirmation-agent/country";
  static String? profile = "${server!}/confirmation-agent/profile";
  static String? wallet = "${server!}/confirmation-agent/wallet/history";
  static String? orderList = "${server!}/confirmation-agent/order";
  static String? orderConfirmAssignList = "${server!}/confirmation-agent/order/assign";
  static String? orderConfirmList = "${server!}/confirmation-agent/order/approved";
  static String? orderStatusUpdate = "${server!}/confirmation-agent/order/update-status";
  static String? orderPreview = "${server!}/confirmation-agent/order/order-preview/";
  static String? commissionHistory = "${server!}/confirmation-agent/commission/history";
  static String? withdrawRequest = "${server!}/confirmation-agent/withdrawRequest/history";
  static String? withdrawRequestStore = "${server!}/confirmation-agent/withdrawRequest/store";
  static String? dashboard = "${server!}/confirmation-agent/dashboard";
  static String? documentTypes = "${server!}/confirmation-agent/document-types";
  static String? confirmationDocumentsStore = "${server!}/confirmation-agent/documents/store";
  static String? logout = "${server!}sign-out";
  static String? refreshToken = "${server!}refresh";
  static String? orderCallToken = "${server!}/confirmation-agent/order-call/token";
  static String? deleteAccount = '${server!}account/delete';

}
