import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant_colors.dart';
import '../controller/profile_controller.dart';
import '../model/profileModel.dart';
import 'confirmation_agent_documents_upload.dart';

class ConfirmationAgentDocumentsView extends GetView<ProfileController> {
  const ConfirmationAgentDocumentsView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
        title: const Text(
          'Verification Documents',
          style: TextStyle(
            color: Colors.white, // Title color
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        icon: const Icon(Icons.upload_file, color: Colors.white),
        label: const Text(
          'Upload',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: ()  {
           Get.to(
                () => ConfirmationAgentDocumentsUpload(),
            transition: Transition.downToUp,
          );
        },
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final detail = controller.userDetails.value?.confirmationAgentDetail;

        if (detail == null) {
          return const Center(child: Text('No data found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ---------------- Agent Info Card ----------------
              _infoCard(detail),

              const SizedBox(height: 20),

              /// ---------------- Documents Section ----------------
              Text(
                'Uploaded Documents',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.confirmationAgentDocuments.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (_, index) {
                  final doc = controller.confirmationAgentDocuments[index];
                  return _documentCard(doc);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  /// ---------------- Agent Info Card ----------------
  Widget _infoCard(ConfirmationAgentDetail detail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _infoRow('NID Number', detail.nidNumber),
          _infoRow('Passport Number', detail.passportNumber),
          _infoRow('Status', _statusText(detail.status??1)),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(int status) {
    switch (status) {
      case 1:
        return 'Pending';
      case 2:
        return 'Under Review';
        case 3:
        return 'Approved';
      case 4:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  /// ---------------- Document Card ----------------
  Widget _documentCard(ConfirmationAgentDocuments doc) {
    return InkWell(
      onTap: () {
        Get.to(() => FullImageView(imageUrl: doc.fileUrl??''));
      },
      child: Container(
        decoration: _boxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: doc.fileUrl??"",
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                doc.documentTypeName??'',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}


class FullImageView extends StatelessWidget {
  final String imageUrl;

  const FullImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
