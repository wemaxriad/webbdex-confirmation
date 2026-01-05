class ApiList {
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
  static String? dashboard = "${server!}/confirmation-agent/dashboard";
  static String? documentTypes = "${server!}/confirmation-agent/document-types";
  static String? confirmationDocumentsStore = "${server!}/confirmation-agent/documents/store";
  static String? logout = "${server!}sign-out";
  static String? refreshToken = "${server!}refresh";
  static String? deleteAccount = '${server!}account/delete';

}
