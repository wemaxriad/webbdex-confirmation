import 'package:get/get.dart';
import '../models/order_model.dart';

class OrdersController extends GetxController {
  RxList<OrderModel> orderList = <OrderModel>[].obs;
  RxList<OrderModel> filteredList = <OrderModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() async {
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data (replace with API response later)
    orderList.value = [
      OrderModel(
        orderId: "1234567",
        orderType: "shipment",
        status: "pending",
        totalAmount: "250.00",
        paymentStatus: "pending",
        trackingNumber: "",
        date: "Dec 28, 2025 13:04:20",
        carrier: "View",
        customerName: "John Doe",
      ),
      OrderModel(
        orderId: "123456",
        orderType: "shipment",
        status: "pending",
        totalAmount: "250.00",
        paymentStatus: "pending",
        trackingNumber: "",
        date: "Dec 28, 2025 13:02:59",
        carrier: "View",
        customerName: "Jane Doe",
      ),
    ];

    filteredList.assignAll(orderList);
    isLoading.value = false;
  }

  // SEARCH FUNCTION
  void filterOrders(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(orderList);
    } else {
      filteredList.assignAll(
        orderList.where((order) =>
            order.orderId.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }
}
