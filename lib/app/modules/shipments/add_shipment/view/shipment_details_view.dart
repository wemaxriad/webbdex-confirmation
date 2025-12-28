import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_carry/app/routes/app_pages.dart';
import 'package:i_carry/app/utils/constants/colors.dart';
import '../controller/shipment_details_controller.dart';

class ShipmentDetailsView extends GetView<ShipmentDetailsController> {
  const ShipmentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Shipment Details",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Get.toNamed(Routes.SHIPMENTS);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Content Dropdown
            const Text(
              "What is inside your package? *",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Obx(
              () => DropdownButtonFormField<DropdownOption?>(
                value: controller.selectedPackageContent.value,
                hint: const Text("What is inside your package?"),
                items: controller.packageContentOptions.map((DropdownOption option) {
                  return DropdownMenuItem<DropdownOption>(
                    value: option,
                    child: Row(
                      children: [
                        Icon(option.icon, color: Colors.grey.shade600),
                        const SizedBox(width: 10),
                        Text(option.title),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  controller.selectedPackageContent.value = newValue;
                },
                decoration: _inputDecoration(),
                selectedItemBuilder: (BuildContext context) {
                  return controller.packageContentOptions.map<Widget>((DropdownOption item) {
                    return Row(
                      children: [
                        Icon(item.icon, color: Colors.grey.shade600),
                        const SizedBox(width: 10),
                        Text(item.title),
                      ],
                    );
                  }).toList();
                },
              ),
            ),
            Obx(() {
              if (controller.showCalculator.value) {
                return _buildCalculator();
              } else if (controller.showParcelForm.value) {
                return _buildParcelForm();
              } else if (controller.showProductForm.value) {
                return _buildProductForm();
              } else {
                return const SizedBox.shrink();
              }
            }),
            const SizedBox(height: 24),

            // Stickers Dropdown
            const Text(
              "Select Stickers *",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildStickerSelector(context),
            const SizedBox(height: 24),

            // External ID
            const Text(
              "External ID",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.externalIdController,
              label: "External ID",
            ),
            const SizedBox(height: 16),

            // Additional Information
            const Text(
              "Additional information about the package",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.additionalInfoController,
              label: "Additional information about the package",
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            // NEXT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  CustomColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: controller.goToCarriers, // <-- CORRECTED
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? suffixText}) {
    return InputDecoration(
      suffixText: suffixText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: CustomColor.primaryColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildStickerSelector(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: const Text('Select Stickers'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.stickerOptions.length,
                itemBuilder: (context, index) {
                  final option = controller.stickerOptions[index];
                  return Obx(() => CheckboxListTile(
                        title: Row(
                          children: [
                            Icon(option.icon, color: Colors.grey.shade600),
                            const SizedBox(width: 10),
                            Text(option.title),
                          ],
                        ),
                        value: controller.selectedStickers.contains(option),
                        onChanged: (bool? value) {
                          controller.toggleSticker(option);
                        },
                      ));
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('DONE'),
              ),
            ],
          ),
        );
      },
      child: InputDecorator(
        decoration: _inputDecoration().copyWith(
          contentPadding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: controller.selectedStickers.isEmpty
                    ? const Text("Select sticker")
                    : Wrap(
                        spacing: 6.0,
                        children: controller.selectedStickers.map((sticker) {
                          return Chip(
                            avatar: Icon(sticker.icon, size: 16, color: Colors.black54),
                            label: Text(sticker.title, style: const TextStyle(fontSize: 12)),
                            onDeleted: () => controller.toggleSticker(sticker),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.all(2),
                          );
                        }).toList(),
                      ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculator() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text("Gross: ${controller.grossWeight.value.toStringAsFixed(1)} kg"),
                      ),
                      Flexible(
                        child: Text("Volumetric: ${controller.volumetricWeight.value.toStringAsFixed(1)} kg"),
                      ),
                      Flexible(
                        child: Text("Chargeable: ${controller.chargeableWeight.value.toStringAsFixed(1)} kg"),
                      ),
                    ],
                  )),
              const SizedBox(height: 16),
              const Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildCalculatorTextField(controller.weightController, "kg"),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildDimensionField("Length", controller.lengthController, "cm"),
                  const SizedBox(width: 16),
                  _buildDimensionField("Width", controller.widthController, "cm"),
                  const SizedBox(width: 16),
                  _buildDimensionField("Height", controller.heightController, "cm"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildTotalWeightContainer(),
      ],
    );
  }

  Widget _buildParcelForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Column(
            children: controller.parcels.map((parcel) => _buildParcelItem(parcel)).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(label: "Description *", controller: controller.descriptionController, maxLines: 3),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildTextField(label: "Parcel Value", controller: controller.parcelValueController)),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: controller.selectedCurrency.value,
                items: controller.currencyOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    controller.selectedCurrency.value = newValue;
                  }
                },
                decoration: _inputDecoration(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => CheckboxListTile(
              title: const Text("Fresh food"),
              value: controller.isFreshFood.value,
              onChanged: (newValue) {
                controller.isFreshFood.value = newValue ?? false;
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            )),
        const SizedBox(height: 16),
        _buildTotalWeightContainer(),
      ],
    );
  }

  Widget _buildProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Column(
            children: controller.products.map((product) => _buildProductItem(product)).toList(),
          ),
        ),
        Obx(() => CheckboxListTile(
              title: const Text("Multi-piece"),
              value: controller.isMultiPiece.value,
              onChanged: controller.toggleMultiPiece,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            )),
        const SizedBox(height: 16),
        _buildTotalWeightContainer(),
        const SizedBox(height: 16),
        Obx(() => CheckboxListTile(
              title: const Text("Fresh food"),
              value: controller.isFreshFood.value,
              onChanged: (newValue) {
                controller.isFreshFood.value = newValue ?? false;
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }

  Widget _buildProductItem(Product product) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Product ${product.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (controller.products.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => controller.removeProduct(product.id),
              ),
            ),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("Gross: ${product.grossWeight.value.toStringAsFixed(1)} kg")),
                  Flexible(child: Text("Volumetric: ${product.volumetricWeight.value.toStringAsFixed(1)} kg")),
                  Flexible(child: Text("Chargeable: ${product.chargeableWeight.value.toStringAsFixed(1)} kg")),
                ],
              )),
          const SizedBox(height: 16),
          DropdownButtonFormField<BoxOption>(
            value: product.selectedBox.value,
            items: product.boxOptions.map((BoxOption option) {
              return DropdownMenuItem<BoxOption>(
                value: option,
                child: Text(option.toString()),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                product.selectedBox.value = newValue;
              }
            },
            decoration: _inputDecoration(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: product.decrement),
                  Obx(() => Text("${product.quantity.value}", style: const TextStyle(fontSize: 16))),
                  IconButton(icon: const Icon(Icons.add), onPressed: product.increment),
                ],
              ),
              Obx(() => Text("Total: \$${product.total.value.toStringAsFixed(1)}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
            ],
          ),
          if (controller.isMultiPiece.value)
            TextButton.icon(
              onPressed: controller.addProduct,
              icon: const Icon(Icons.add_circle_outline, color: CustomColor.primaryColor),
              label: const Text("Add Product", style: TextStyle(color: Color(0xFFF4B528))),
            ),
        ],
      ),
    );
  }

  Widget _buildParcelItem(Parcel parcel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Parcel ${parcel.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (controller.parcels.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => controller.removeParcel(parcel.id),
              ),
            ),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text("Gross: ${parcel.grossWeight.value.toStringAsFixed(1)} kg")),
                  Flexible(child: Text("Volumetric: ${parcel.volumetricWeight.value.toStringAsFixed(1)} kg")),
                  Flexible(child: Text("Chargeable: ${parcel.chargeableWeight.value.toStringAsFixed(1)} kg")),
                ],
              )),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField(label: "Name", controller: parcel.nameController)),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField(label: "Quantity", controller: parcel.quantityController, keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTextField(label: "Price", controller: parcel.priceController, keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: _buildTextField(label: "Total", controller: parcel.totalController, keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTotalWeightContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Total Chargeable Weight", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("0.00 kg", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _buildCalculatorTextField(TextEditingController controller, String suffixText) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(suffixText: suffixText),
    );
  }

  Widget _buildDimensionField(String label, TextEditingController controller, String suffixText) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildCalculatorTextField(controller, suffixText),
        ],
      ),
    );
  }
}
