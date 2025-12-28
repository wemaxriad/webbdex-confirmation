import 'package:get/get.dart';

class CarrierManagementController extends GetxController {
  final carriers = <Map<String, dynamic>>[
    {
      'name': 'Fedex',
      'status': 'Active',
      'lastUpdated': DateTime.now(),
      'email': 'support@fedex.com',
      'website': 'https://www.fedex.com',
      'phone': '+18004633339',
      'description': 'FedEx Corporation is an American multinational courier delivery services company.',
      'address': 'Memphis, TN, USA',
      'configuration': {
        'api_key': 'key_goes_here',
        'secret_key': 'secret_goes_here',
        'shipping_location': 'Global',
        'account': '123456789',
        'test_url': 'https://apis-sandbox.fedex.com'
      }
    },
  ].obs;

  int get totalCarriers => carriers.length;
  int get activeCarriers => carriers.where((c) => c['status'] == 'Active').length;
  int get inactiveCarriers => carriers.where((c) => c['status'] == 'Inactive').length;

  void addCarrier(Map<String, dynamic> carrier) {
    carriers.add(carrier);
  }

  void updateCarrier(int index, Map<String, dynamic> carrier) {
    carriers[index] = carrier;
  }

  void toggleCarrierStatus(int index) {
    final carrier = carriers[index];
    carrier['status'] = carrier['status'] == 'Active' ? 'Inactive' : 'Active';
    carrier['lastUpdated'] = DateTime.now();
    carriers[index] = carrier;
  }

  void deleteCarrier(int index) {
    carriers.removeAt(index);
  }
}
