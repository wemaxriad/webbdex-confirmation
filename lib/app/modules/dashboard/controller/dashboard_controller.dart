import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../model/order_model.dart';
import '../../../services/server.dart';
import '../../../services/user-service.dart';
import '../model/dashboardModel.dart';
import '../service/dashboard_service.dart';

class DashboardController extends GetxController {

  Server server = Server();
  UserService userService = UserService();

  // FIX: Add currentIndex for the bottom navigation bar management
  var currentIndex = 0.obs;

  final DashboardService _service = DashboardService();

  RxBool isLoading = true.obs;

  RxInt totalAssignedOrder = 0.obs;
  RxInt totalApprovedOrder = 0.obs;
  RxInt totalCancelOrder = 0.obs;
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

  RxList<LastAssignedOrders> lastOrders = <LastAssignedOrders>[].obs;
  Rx<UserDetails?> userDetails = Rx<UserDetails?>(null);

  @override
  void onInit() {
    super.onInit();
    getDashboard();
  }

  Future<void> getDashboard() async {
    try {
      isLoading(true);

      final DashboardData? data = await _service.getDashboardData();

      if (data != null) {
        print(data.totalApprovedOrder);
        totalAssignedOrder.value = data.totalAssignedOrder ?? 0;
        totalApprovedOrder.value = data.totalApprovedOrder ?? 0;
        totalCancelOrder.value = data.totalCancelOrder ?? 0;

        lastOrders.assignAll(data.lastAssignedOrders ?? []);
        userDetails.value = data.userDetails;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshDashboard() async {
    await getDashboard();
    Get.snackbar('Success', 'Dashboard refreshed');
  }
}

