import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../controller/manage_team_controller.dart';
import 'add_member_view.dart';

class ManageTeamView extends GetView<ManageTeamController> {
  const ManageTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Members",
        style: TextStyle(
          color: Colors.white
        ),
        ),
        backgroundColor: CustomColor.primaryColor,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          Get.to(() => AddMemberView());
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔍 SEARCH BAR
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(color: Colors.black12),
            //   ),
            //   child: TextField(
            //     controller: controller.searchController,
            //     decoration: const InputDecoration(
            //       border: InputBorder.none,
            //       hintText: "Search",
            //     ),
            //   ),
            // ),

            const SizedBox(height: 16),

            // TEAM MEMBER LIST
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.filteredMembers.length,
                itemBuilder: (context, index) {
                  var member = controller.filteredMembers[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Row(
                      children: [

                        // ICON
                        const Icon(Icons.person_outline,
                            color: Colors.orange, size: 30),

                        const SizedBox(width: 15),

                        // TEXT
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(member["name"]!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            Text(member["email"]!,
                                style: const TextStyle(
                                    color: Colors.black54)),
                            Text(member["phone"]!,
                                style: const TextStyle(
                                    color: Colors.black54)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )),
            )
          ],
        ),
      ),
    );
  }
}
