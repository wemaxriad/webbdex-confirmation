// // TODO Implement this library.
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/faield_request_controller.dart';
//
// class FailedRequestsView extends StatelessWidget {
//   const FailedRequestsView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<FailedRequestsController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() => Text(controller.title.value)),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.failedRequests.isEmpty) {
//           return const Center(
//             child: Text("No failed requests available"),
//           );
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: controller.failedRequests.length,
//           itemBuilder: (context, index) {
//             final item = controller.failedRequests[index];
//
//             return Card(
//               elevation: 2,
//               margin: const EdgeInsets.only(bottom: 12),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.red,
//                   child: Text(
//                     item["id"].toString(),
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 title: Text(item["reason"]),
//                 subtitle: Text(item["date"]),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/field_request_controller.dart';

class FailedRequestsView extends StatelessWidget {
  const FailedRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FailedRequestsController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by ID or Reason...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
              },
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredList.isEmpty) {
                return const Center(child: Text("No failed requests found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.filteredList.length,
                itemBuilder: (context, index) {
                  final item = controller.filteredList[index];

                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: const Icon(Icons.error, color: Colors.white),
                      ),
                      title: Text(item["id"]),
                      subtitle: Text("${item['reason']} • ${item['date']}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                      onTap: () {},
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
