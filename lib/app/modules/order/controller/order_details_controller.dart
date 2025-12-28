import 'package:confirmation_agent_app/app/model/order_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../services/mock_order_service.dart';

class OrderDetailsController extends GetxController {
  var isLoading = true.obs;

  // Use the Order model for type safety
  var order = Rxn<Order>();

  final int orderId;
  final MockOrderService _orderService = MockOrderService();

  OrderDetailsController(this.orderId);

  @override
  void onInit() {
    fetchOrderDetails();
    super.onInit();
  }

  Future<void> fetchOrderDetails() async {
    try {
      isLoading(true);
      await Future.delayed(const Duration(seconds: 1));

      // Find the order from the centralized service
      final fetchedOrder = _orderService.getOrders().firstWhere(
            (o) => o.id == orderId,
        orElse: () => _orderService.getOrders().first, // Fallback
      );

      order.value = fetchedOrder;

    } catch (e) {
      debugPrint("Error fetching order details: $e");
      Get.snackbar("Error", "Could not load order details.");
    } finally {
      isLoading(false);
    }
  }

  void markOrderPicked() {
    Get.snackbar(
      'Action',
      'Order $orderId marked as Picked Up.',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Add actual API call and state management here
  }

  void requestRefund(int itemIndex) {
    if (order.value != null) {
      final itemName = order.value!.items[itemIndex].name;
      Get.snackbar(
        "Refund Requested",
        "Refund request submitted for $itemName",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
