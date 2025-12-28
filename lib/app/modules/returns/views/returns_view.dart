// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/returns_controller.dart';

class ReturnsView extends StatelessWidget {
  final ReturnController controller = Get.put(ReturnController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Return Shipment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tracking ID"),
            TextField(
              onChanged: (value) => controller.trackingId.value = value,
              decoration: InputDecoration(
                hintText: "Enter tracking number",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Text("Reason for Return"),
            TextField(
              maxLines: 3,
              onChanged: (value) => controller.reason.value = value,
              decoration: InputDecoration(
                hintText: "Write your reason...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            Obx(() => controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: controller.submitReturn,
              child: Text("Submit Return"),
            )),
          ],
        ),
      ),
    );
  }
}

