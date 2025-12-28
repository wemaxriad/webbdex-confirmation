import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/services/shipment_data_service.dart';

// --- MODELS ---

class DropdownOption {
  final IconData icon;
  final String title;

  DropdownOption({required this.icon, required this.title});
}

class BoxOption {
  final String name;
  final double weight;
  final double price;

  BoxOption({required this.name, required this.weight, required this.price});

  @override
  String toString() => '$name (\$${price.toStringAsFixed(2)})';
}

class Product {
  final int id;
  final grossWeight = 0.0.obs;
  final volumetricWeight = 0.0.obs;
  final chargeableWeight = 0.0.obs;
  final quantity = 1.obs;
  final total = 0.0.obs;

  final boxOptions = <BoxOption>[
    BoxOption(name: "Box 1", weight: 2.5, price: 10),
    BoxOption(name: "Box 2", weight: 5.0, price: 18),
  ].obs;
  final selectedBox = Rx<BoxOption?>(null);

  Product(this.id);

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }
}

class Parcel {
  final int id;
  final grossWeight = 0.0.obs;
  final volumetricWeight = 0.0.obs;
  final chargeableWeight = 0.0.obs;
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final totalController = TextEditingController();

  Parcel(this.id);

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    priceController.dispose();
    totalController.dispose();
  }
}


// --- CONTROLLER ---

class ShipmentDetailsController extends GetxController {
  // For 'What is inside your package?' Dropdown
  final packageContentOptions = [
    DropdownOption(icon: Icons.card_giftcard, title: "Document"),
    DropdownOption(icon: Icons.receipt_long, title: "Parcel"),
    DropdownOption(icon: Icons.inventory_2, title: "Product"),
  ].obs;
  final selectedPackageContent = Rx<DropdownOption?>(null);

  // Controllers for dynamically shown forms
  final weightController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final descriptionController = TextEditingController();
  final parcelValueController = TextEditingController();
  final selectedCurrency = "USD".obs;
  final currencyOptions = ["USD", "EUR", "GBP"].obs;
  var parcels = <Parcel>[Parcel(1)].obs;
  var products = <Product>[Product(1)].obs;

  // For Stickers Dropdown
  final stickerOptions = [
    DropdownOption(icon: Icons.ac_unit, title: "Fragile"),
    DropdownOption(icon: Icons.access_alarm, title: "Dangerous"),
    DropdownOption(icon: Icons.access_alarm, title: "Temperature Controlled"),
  ].obs;
  final selectedStickers = <DropdownOption>[].obs;

  // For External ID & Additional Info
  final externalIdController = TextEditingController();
  final additionalInfoController = TextEditingController();

  // Observables to control UI visibility
  final showCalculator = false.obs;
  final showParcelForm = false.obs;
  final showProductForm = false.obs;
  final isFreshFood = false.obs;
  final isMultiPiece = false.obs;

  // Calculated weights
  final grossWeight = 0.0.obs;
  final volumetricWeight = 0.0.obs;
  final chargeableWeight = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // When the main dropdown changes, update which form is visible
    selectedPackageContent.listen((option) {
      showCalculator.value = option?.title == "Document";
      showParcelForm.value = option?.title == "Parcel";
      showProductForm.value = option?.title == "Product";
    });
  }

  void toggleSticker(DropdownOption option) {
    if (selectedStickers.contains(option)) {
      selectedStickers.remove(option);
    } else {
      selectedStickers.add(option);
    }
  }
  
  void toggleMultiPiece(bool? value) {
    isMultiPiece.value = value ?? false;
    if (!isMultiPiece.value && products.length > 1) {
      products.value = [products.first];
    }
  }

  void addParcel() {
    parcels.add(Parcel(parcels.length + 1));
  }

  void removeParcel(int id) {
    if(parcels.length > 1) {
        parcels.removeWhere((p) => p.id == id);
    }
  }
  
  void addProduct() {
     products.add(Product(products.length + 1));
  }
  
  void removeProduct(int id) {
    if(products.length > 1) {
      products.removeWhere((p) => p.id == id);
    }
  }

  void goToCarriers() {
    final shipmentDataService = Get.find<ShipmentDataService>();

    final packageData = {
      'packageContent': selectedPackageContent.value?.title,
      'weight': chargeableWeight.value,
      'length': lengthController.text,
      'width': widthController.text,
      'height': heightController.text,
      'description': descriptionController.text,
      'parcelValue': parcelValueController.text,
      'currency': selectedCurrency.value,
      'externalId': externalIdController.text,
      'additionalInfo': additionalInfoController.text,
      'stickers': selectedStickers.map((s) => s.title).toList(),
    };

    shipmentDataService.packageData.value = packageData;

    Get.toNamed(Routes.CARRIERS);
  }

  @override
  void onClose() {
    // Dispose all text controllers to prevent memory leaks
    weightController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    descriptionController.dispose();
    parcelValueController.dispose();
    externalIdController.dispose();
    additionalInfoController.dispose();
    for (var parcel in parcels) {
      parcel.dispose();
    }
    super.onClose();
  }
}
