import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/manage_team_controller.dart';

class AddMemberView extends StatelessWidget {
  AddMemberView({super.key});

  final controller = Get.find<ManageTeamController>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Member",
        style: TextStyle(
          color: Colors.white
        ),
        ),
        backgroundColor: CustomColor.primaryColor,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            field("First Name *", firstName),
            field("Last Name *", lastName),
            field("Email *", email),
            field("Phone *", phone),
            field("Password *", password, isPassword: true),

            const Spacer(),

            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                child: const Text("Save",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: () {
                  controller.addMember({
                    "name": "${firstName.text} ${lastName.text}",
                    "email": email.text,
                    "phone": phone.text,
                  });
                  Get.back();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget field(String label, TextEditingController c,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          controller: c,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
