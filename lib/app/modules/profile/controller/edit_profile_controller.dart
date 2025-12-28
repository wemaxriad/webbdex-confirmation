import 'package:confirmation_agent_app/app/modules/auth/controllers/signup_controller.dart';
import 'package:confirmation_agent_app/app/modules/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  // Find existing controllers
  final ProfileController profileController = Get.find<ProfileController>();
  final SignUpController signUpController = Get.put(SignUpController());

  // Text editing controllers for the form fields
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController zipCodeController;
  late TextEditingController userNameController;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with the current profile data
    fullNameController = TextEditingController(text: profileController.name.value);
    emailController = TextEditingController(text: profileController.email.value);
    phoneController = TextEditingController(text: profileController.phone.value);

    // Placeholders for username and zip, as they aren't in the ProfileController
    userNameController = TextEditingController(text: "asm");
    zipCodeController = TextEditingController(text: "12345");

    // Set the initial value for the country dropdown
    signUpController.selectedCountry.value = profileController.country.value;
  }

  // --- Update Profile Logic ---
  void updateProfile() {
    // Update the ProfileController with the new values from the form
    profileController.name.value = fullNameController.text;
    profileController.email.value = emailController.text;
    profileController.phone.value = phoneController.text;
    profileController.country.value = signUpController.selectedCountry.value ?? '';

    Get.back(); // Go back to the profile page
    Get.snackbar('Success', 'Profile updated successfully!');
  }

  // --- Change Profile Image ---
  void changeProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      profileController.profileImage.value = image.path;
      Get.snackbar('Success', 'Profile image updated!');
    } else {
      Get.snackbar('Info', 'No image selected.');
    }
  }

  @override
  void onClose() {
    // Dispose controllers to free up resources
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    userNameController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }
}
