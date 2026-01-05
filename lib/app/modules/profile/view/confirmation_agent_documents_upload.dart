import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant_colors.dart';
import '../controller/profile_controller.dart';
import '../model/documentTypesModel.dart';

class ConfirmationAgentDocumentsUpload extends StatelessWidget {
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Documents Update',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(
            () =>  SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PERSONAL INFO (Static)
          _sectionTitle('Personal Info'),
          _textFieldController('NID Number', controller.userDetails.value?.confirmationAgentDetail?.nidNumber??'',controller.nidController),
          _textFieldController('Passport Number', controller.userDetails.value?.confirmationAgentDetail?.passportNumber??'',controller.passportController),

          const SizedBox(height: 20),

          /// DOCUMENTS
          _sectionTitle('Documents'),

          ...controller.documentTypes.map(
                (doc) => _documentPicker(
              controller,
              doc,
            ),
          ),

          const SizedBox(height: 30),

          /// SUBMIT
          Obx(() => SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () {
                controller.submitDocuments(
                  nidNumber: controller.nidController.text,
                  passportNumber: controller.passportController.text,
                );
              },
              child: controller.isSubmitting.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Documents'),
            ),
          )),
        ],
      ),
    )
      ),
    );
  }



  Widget _documentPicker(
      ProfileController controller,
      DocumentTypes doc,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: doc.name ?? '',
            children: [
              if (doc.isRequired == true)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        InkWell(
          onTap: () => showImageSourceSheet(
            Get.context!,
            controller,
            doc.slug!,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.upload_file),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() {
                    final file = controller.selectedFiles[doc.slug];
                    return Text(
                      file != null
                          ? file.path.split('/').last
                          : 'Choose File',
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }


  void showImageSourceSheet(
      BuildContext context,
      ProfileController controller,
      String slug,
      ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                controller.pickFile(slug, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                controller.pickFile(slug, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFieldController(String label, String value, textController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: textController,
        readOnly: false,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

}
