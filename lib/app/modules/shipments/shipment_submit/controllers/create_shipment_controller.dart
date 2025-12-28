import 'package:get/get.dart';
import 'package:i_carry/app/services/shipment_data_service.dart';
import 'package:intl/intl.dart';

class CreateShipmentController extends GetxController {
  final ShipmentDataService _shipmentDataService = Get.find<ShipmentDataService>();

  // Observables for the shipment summary.
  final senderInfo = <String, dynamic>{}.obs;
  final recipientInfo = <String, dynamic>{}.obs;
  final orderDetails = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDataFromService();
  }

  void _loadDataFromService() {
    senderInfo.value = _shipmentDataService.senderData;
    recipientInfo.value = _shipmentDataService.recipientData;

    // Combine package and carrier data into the orderDetails map
    orderDetails.value = {
      ..._shipmentDataService.packageData,
      ..._shipmentDataService.carrierData,
    };
  }

  Map<String, dynamic> _formatNewShipment() {
    final trackingId = "IC${DateTime.now().millisecondsSinceEpoch}";
    final currentDate = DateFormat("MM/dd/yyyy h:mm:ss a").format(DateTime.now());

    return {
      "tracking": trackingId,
      "date": currentDate,
      "status": "Draft", // Default status
      "from": senderInfo['Location'] ?? 'N/A',
      "to": recipientInfo['Location'] ?? 'N/A',
      "sender": senderInfo['name'] ?? 'N/A',
      "carrier": orderDetails['carrierName'] ?? 'N/A',
      "recipient": recipientInfo['name'] ?? 'N/A',
    };
  }

  void processShipment() {
    if (senderInfo.isEmpty || recipientInfo.isEmpty) {
      Get.snackbar("Error", "Sender or Recipient information is missing.");
      return;
    }

    final newShipment = _formatNewShipment();
    _shipmentDataService.addNewShipment(newShipment);

    Get.snackbar("Success", "New shipment has been created.");

    // Clear the temporary data from the service
    _shipmentDataService.clearData();
  }
}
