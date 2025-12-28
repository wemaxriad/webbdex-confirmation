// import 'package:confirmation_agent_app/app/model/order_model.dart';
//
// class MockOrderService {
//   static final MockOrderService _instance = MockOrderService._internal();
//   factory MockOrderService() => _instance;
//
//   late List<Order> _orders;
//
//   MockOrderService._internal() {
//     _generateMockOrders();
//   }
//
//   void _generateMockOrders() {
//     _orders = List.generate(10, (index) {
//       String status;
//       String customerName;
//
//       if (index == 0) {
//         status = "Pending";
//         customerName = "asm"; // Matches screenshot name
//       } else {
//         status = ["Confirmed", "Canceled", "Pending"][index % 3];
//         customerName = "customer ${index + 1}";
//       }
//
//       List<OrderItem> items = List.generate(
//         (index % 3) + 1, // Vary the number of items
//             (i) => OrderItem(
//           name: "Product ${i + 1} for Order ${2000 + index}",
//           price: 10.0 + (i * 5),
//           qty: (i + 1),
//         ),
//       );
//
//       return Order(
//         id: 2000 + index,
//         status: status,
//         items: items,
//         customerName: customerName,
//         pickupLocation: "Barbar",
//         deliveryLocation: "Budaiya",
//       );
//     });
//   }
//
//   List<Order> getOrders() {
//     return _orders;
//   }
//
//   void refreshOrders(){
//     _generateMockOrders();
//   }
// }
import 'package:confirmation_agent_app/app/model/order_model.dart';

class MockOrderService {
  static final MockOrderService _instance = MockOrderService._internal();
  factory MockOrderService() => _instance;

  late List<Order> _orders;

  MockOrderService._internal() {
    _generateMockOrders();
  }

  void _generateMockOrders() {
    _orders = List.generate(10, (index) {
      // ---- Order status ----
      String status;
      if (index == 0) {
        status = "Pending";
      } else {
        status = ["Confirmed", "Canceled", "Pending"][index % 3];
      }

      // ---- Payment status ----
      String paymentStatus =
      index % 2 == 0 ? "paid" : "pending"; // paid / pending

      // ---- Order items ----
      List<OrderItem> items = List.generate(
        (index % 3) + 1,
            (i) => OrderItem(
          name: "Product ${i + 1}",
          price: 20.0 + (i * 10),
          qty: i + 1,
        ),
      );

      // ---- Calculations ----
      double discount = index % 2 == 0 ? 5.0 : 0.0;
      double tax = 2.5;
      double shipping = 3.0;

      return Order(
        id: 2000 + index,
        status: status,
        items: items,

        // Payment info
        paymentStatus: paymentStatus,
        paymentMethod: "cash_on_delivery",

        // Pricing
        discount: discount,
        tax: tax,
        shippingCost: shipping,

        // User & location
        customerName: index == 0 ? "asm" : "Customer ${index + 1}",
        pickupLocation: "Barbar",
        deliveryLocation: "Budaiya",
      );
    });
  }

  List<Order> getOrders() => _orders;

  void refreshOrders() {
    _generateMockOrders();
  }
}
