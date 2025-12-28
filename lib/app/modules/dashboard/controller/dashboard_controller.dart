import 'package:confirmation_agent_app/app/services/mock_order_service.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../model/order_model.dart';

class DashboardController extends GetxController {

  final MockOrderService _orderService = MockOrderService();

  // FIX: Add currentIndex for the bottom navigation bar management
  var currentIndex = 0.obs;

  // --- Dashboard Data ---
  var totalBalance = 15000.obs;
  var pendingBalance = 2345.obs;
  var totalOrders = 0.obs;      // Will be calculated
  var totalConfirmed = 0.obs;   // Renamed and will be calculated
  var totalCanceled = 0.obs;    // Renamed and will be calculated
  var totalPending = 0.obs;     // Renamed and will be calculated

  // Combined list for all orders
  var allOrders = <Order>[].obs;
  // Separate list for the dashboard's "Recent Orders"
  var recentOrders = <Order>[].obs;

  // --- Change Status Dialog State ---
  var selectedStatus = 'Select Status'.obs;
  var statusNotes = ''.obs;
  var statusOptions = [
    'Select Status',
    'Confirmed',
    'Canceled',
  ];

  @override
  void onInit() {
    _loadOrders();
    super.onInit();
  }

  Future<void> refreshDashboard() async {
    // Simulate a network call to refresh data
    await Future.delayed(const Duration(seconds: 2));
    _orderService.refreshOrders();
    _loadOrders();
    Get.snackbar('Success', 'Dashboard has been refreshed');
  }

  void _loadOrders() {
    final orders = _orderService.getOrders();
    allOrders.value = orders;
    recentOrders.value = orders.take(5).toList();

    // --- Calculate Stats ---
    totalOrders.value = allOrders.length;
    totalConfirmed.value = allOrders.where((o) => o.status == 'Confirmed').length;
    totalCanceled.value = allOrders.where((o) => o.status == 'Canceled').length;
    totalPending.value = allOrders.where((o) => o.status == 'Pending').length;
  }

  // --- Status Change Logic ---
  void updateSelectedStatus(String? newStatus) {
    if (newStatus != null) {
      selectedStatus.value = newStatus;
    }
  }

  void updateStatusNotes(String notes) {
    statusNotes.value = notes;
  }

  void submitStatusChange(int orderId) {
    if (selectedStatus.value == 'Select Status') {
      Get.snackbar('Error', 'Please select a new status.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    debugPrint('Submitting status change for Order $orderId: ${selectedStatus.value} with notes: ${statusNotes.value}');

    final orderIndex = allOrders.indexWhere((order) => order.id == orderId);

    if (orderIndex != -1) {
      final updatedOrder = allOrders[orderIndex].copyWith(status: selectedStatus.value);
      allOrders[orderIndex] = updatedOrder;
      
      // Recalculate stats
      _loadOrders();

      selectedStatus.value = 'Select Status';
      statusNotes.value = '';
      Get.back();
      Get.snackbar('Success', 'Order $orderId status updated.', snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Order not found.', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
