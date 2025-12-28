import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/services/shipment_data_service.dart';

class CarriersController extends GetxController {
  var isCod = false.obs;
  var selectedCurrency = "USD".obs;
  var selectedFilter = "Fastest".obs;
  var showCarriers = false.obs;
  var selectedCarrierId = "dhl".obs;

  final amountController = TextEditingController();
  final currencies = ["USD", "EUR", "GBP"];
  final carriers = [
    {
      'id': 'dhl',
      'name': 'DHL',
      'subName': 'Express Worldwide',
      'delivery': '1-2 days',
      'price': '\$25.99',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/a/a2/DHL_Express_logo.svg',
    },
    {
      'id': 'fedex',
      'name': 'FedEx',
      'subName': 'International Priority',
      'delivery': '2-3 days',
      'price': '\$22.50',
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/9/9d/FedEx_Express.svg',
    },
  ].obs;

  void toggleCod(bool? value) {
    isCod.value = value ?? false;
  }

  void updateCurrency(String? newValue) {
    if (newValue != null) {
      selectedCurrency.value = newValue;
    }
  }

  void findCarriers() {
    showCarriers.value = true;
  }

  void goToCreateShipment() {
    final shipmentDataService = Get.find<ShipmentDataService>();

    final selectedCarrier = carriers.firstWhere(
      (c) => c['id'] == selectedCarrierId.value,
      orElse: () => {},
    );

    final carrierData = {
      'isCod': isCod.value,
      'codCurrency': selectedCurrency.value,
      'codAmount': amountController.text,
      'carrierName': selectedCarrier['name'],
      'carrierService': selectedCarrier['subName'],
      'carrierDelivery': selectedCarrier['delivery'],
      'totalCharges': selectedCarrier['price'],
    };

    shipmentDataService.carrierData.value = carrierData;

    Get.toNamed(Routes.CREATE_SHIPMENT);
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
