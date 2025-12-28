import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageTeamController extends GetxController {

  // Search controller
  TextEditingController searchController = TextEditingController();

  // List of team members
  var teamMembers = <Map<String, String>>[
    {
      "name": "Nurul Islam",
      "email": "wedevs002@gmail.com",
      "phone": "+880 1748-714581",
    }
  ].obs;

  // Filtered list
  RxList<Map<String, String>> filteredMembers = <Map<String, String>>[].obs;

  @override
  void onInit() {
    filteredMembers.assignAll(teamMembers);

    searchController.addListener(() {
      filterList(searchController.text);
    });

    super.onInit();
  }

  void filterList(String query) {
    if (query.isEmpty) {
      filteredMembers.assignAll(teamMembers);
    } else {
      filteredMembers.assignAll(
          teamMembers.where((member) =>
          member["name"]!.toLowerCase().contains(query.toLowerCase()) ||
              member["email"]!.toLowerCase().contains(query.toLowerCase()) ||
              member["phone"]!.contains(query))
      );
    }
  }

  // Add new member
  void addMember(Map<String, String> newMember) {
    teamMembers.add(newMember);
    filterList(searchController.text);
  }
}
