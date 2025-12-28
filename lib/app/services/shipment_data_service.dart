import 'package:get/get.dart';

class ShipmentDataService extends GetxService {
  // Temporary data for creating a new shipment
  final senderData = <String, dynamic>{}.obs;
  final recipientData = <String, dynamic>{}.obs;
  final packageData = <String, dynamic>{}.obs;
  final carrierData = <String, dynamic>{}.obs;

  // Master list of all shipments
  final allShipments = <Map<String, dynamic>>[
    {
      "tracking": "IC03251221818670",
      "date": "12/21/2025 1:23:01 PM",
      "status": "Draft",
      "from": "Mirpur-2",
      "to": "Dania Rd, Dhaka, Bangladesh",
      "sender": "Nurul Islam",
      "carrier": "Sundarban Courier",
      "recipient": "john_doe"
    },
    {
      "tracking": "IC03251221818667",
      "date": "12/21/2025 1:18:48 PM",
      "status": "Unassigned Carrier",
      "from": "East Monipur, Dhaka",
      "to": "Dania Rd, Dhaka, Bangladesh",
      "sender": null,
      "carrier": "Pathao",
      "recipient": "jane_doe"
    },
    {
      "tracking": "IC03251127769012",
      "date": "11/27/2025 1:31:25 PM",
      "status": "Unassigned Carrier",
      "from": "Mirpur-2",
      "to": "Farmgate, Dhaka 1215",
      "sender": "Peter Pan",
      "carrier": "SA Paribahan",
      "recipient": "peter_pan"
    },
  ].obs;

  // Method to add a newly created shipment to the master list
  void addNewShipment(Map<String, dynamic> newShipment) {
    allShipments.insert(0, newShipment); // Add to the top of the list
  }

  // Method to clear all temporary data for a new shipment flow.
  void clearData() {
    senderData.clear();
    recipientData.clear();
    packageData.clear();
    carrierData.clear();
  }
}
