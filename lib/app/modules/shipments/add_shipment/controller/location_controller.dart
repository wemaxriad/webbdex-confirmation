import 'package:get/get.dart';

class LocationController extends GetxController {
  var pickupLocation = ''.obs;
  var dropoffLocation = ''.obs;

  // Dummy data for warehouses
  var warehouseLocations = [
    'Warehouse A, 123 Main St, Dubai',
    'Warehouse B, 456 Sheikh Zayed Road, Dubai',
  ].obs;

  // Dummy data for recipients
  var recipientLocations = [
      'Office, 789 Jumeirah Beach, Dubai',
      'Home, 101 Business Bay, Dubai',
    ].obs;

  void setPickup(String value) {
    pickupLocation.value = value;
  }

  void setDropoff(String value) {
    dropoffLocation.value = value;
  }

  void addWarehouse(String newWarehouse) {
    warehouseLocations.add(newWarehouse);
    setPickup(newWarehouse);
  }

  void addRecipient(String newRecipient) {
    recipientLocations.add(newRecipient);
    setDropoff(newRecipient);
  }
}
