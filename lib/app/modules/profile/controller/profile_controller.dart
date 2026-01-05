import 'dart:io';

import 'package:confirmation_agent_app/app/utils/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/user-service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../model/documentTypesModel.dart';
import '../model/profileModel.dart';
import '../service/profile_service.dart';

class ProfileController extends GetxController {
  // Mock login state for demonstration
  var isLoggedIn = true.obs;
  final ProfiledService _service = ProfiledService();
  final UserService _userService = UserService();

  RxBool isLoading = true.obs;
  /// slug -> picked file
  RxMap<String, File?> selectedFiles = <String, File?>{}.obs;
  RxBool isSubmitting = false.obs;
  late TextEditingController nidController = TextEditingController();
  late TextEditingController passportController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  RxList<ConfirmationAgentDocuments> confirmationAgentDocuments = <ConfirmationAgentDocuments>[].obs;
  Rx<UserDetails?> userDetails = Rx<UserDetails?>(null);
  RxList<DocumentTypes> documentTypes = <DocumentTypes>[].obs;

  @override
  void onInit() {
    // Check authentication status here if needed,
    // e.g., using a service or stored token.
    super.onInit();
    getDocumentsType();
    getProfile();
  }

  Future<void> getDocumentsType() async {
    try {
      final DocumentTypesModel? data = await _service.getDocumentTypeData();
      if (data != null) {
        documentTypes.assignAll(data.documentTypes ?? []);
      }
    } finally {

    }
  }

  Future<void> submitDocuments({
    required String nidNumber,
    required String passportNumber,
  }) async {
    if (!validateRequired()) return;

    isSubmitting.value = true;

    final token = await _userService.getToken();

    /// slug -> typeId
    final Map<int, File?> filesById = {};

    for (final doc in documentTypes) {
      final file = selectedFiles[doc.slug];
      if (file != null && doc.id != null) {
        filesById[doc.id!] = file;
      }
    }

    final success = await _service.storeDocuments(
      token: token,
      nidNumber: nidNumber,
      passportNumber: passportNumber,
      files: filesById,
    );

    if (success) {
      // Clear upload state
      selectedFiles.clear();
      nidController.clear();
      passportController.clear();
      getProfile();
      Get.back();
      // Snackbar
      Get.snackbar(
        'Success',
        'Documents saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }

    isSubmitting.value = false;
  }


  Future<void> getProfile() async {
    try {
      isLoading(true);

      final UserDetails? data = await _service.getProfiledData();

      if (data != null) {
        confirmationAgentDocuments.assignAll(data.confirmationAgentDocuments ?? []);
        userDetails.value = data;
        nidController.text = userDetails.value?.confirmationAgentDetail?.nidNumber??'';
        passportController.text = userDetails.value?.confirmationAgentDetail?.passportNumber??'';
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshProfile() async {
    // Simulate a network call to refresh data
    await Future.delayed(const Duration(seconds: 2));
    Get.snackbar('Success', 'Profile has been refreshed');
  }



  Future<void> pickFile(String slug, ImageSource source) async {
    final XFile? file = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (file != null) {
      selectedFiles[slug] = File(file.path);
    }
  }


  bool validateRequired() {
    for (final doc in documentTypes) {
      if (doc.isRequired == true &&
          selectedFiles[doc.slug] == null) {
        Get.snackbar(
          colorText: Colors.white,
          backgroundColor: primaryColor,
          'Required',
          '${doc.name} is required',
        );
        return false;
      }
    }
    return true;
  }



  // Example function to switch to not logged in state
  void toggleLoginStatus() {
    isLoggedIn.value = !isLoggedIn.value;
  }

  void logout() {
    isLoggedIn.value = false;
    Get.find<AuthController>().userLogout();
  }
}
