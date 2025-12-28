// import 'package:flutter/foundation.dart';
//
// class Order {
//   final int id;
//   final String status;
//   final List<OrderItem> items;
//
//   // Recommended additions based on UI requirements:
//   final String customerName;
//   final String pickupLocation;
//   final String deliveryLocation;
//
//   Order({
//     required this.id,
//     required this.status,
//     required this.items,
//     this.customerName = "Default Customer", // Default used if not provided
//     this.pickupLocation = "Default Pickup",
//     this.deliveryLocation = "Default Delivery",
//   });
//
//   // Helper method for state management (highly recommended for immutable classes)
//   Order copyWith({
//     int? id,
//     String? status,
//     List<OrderItem>? items,
//     String? customerName,
//     String? pickupLocation,
//     String? deliveryLocation,
//   }) {
//     return Order(
//       id: id ?? this.id,
//       status: status ?? this.status,
//       items: items ?? this.items,
//       customerName: customerName ?? this.customerName,
//       pickupLocation: pickupLocation ?? this.pickupLocation,
//       deliveryLocation: deliveryLocation ?? this.deliveryLocation,
//     );
//   }
// }
//
// class OrderItem {
//   final String name;
//   final double price;
//   final int qty;
//
//   OrderItem({
//     required this.name,
//     required this.price,
//     required this.qty
//   });
// }
import 'package:flutter/foundation.dart';

class Order {
  final int id;
  final String status; // Order status (pending, confirmed, etc)
  final String paymentStatus; // pending / paid
  final String paymentMethod; // cash_on_delivery, card, etc

  final double subtotal;
  final double discount;
  final double tax;
  final double shippingCost;
  final double total;

  final List<OrderItem> items;

  // Extra info (safe to keep)
  final String customerName;
  final String pickupLocation;
  final String deliveryLocation;

  Order({
    required this.id,
    required this.status,
    required this.items,

    // Payment & price info
    this.paymentStatus = "pending",
    this.paymentMethod = "cash_on_delivery",
    double? subtotal,
    this.discount = 0.0,
    this.tax = 0.0,
    this.shippingCost = 0.0,

    // Locations & user
    this.customerName = "Default Customer",
    this.pickupLocation = "Default Pickup",
    this.deliveryLocation = "Default Delivery",
  })  : subtotal = subtotal ??
      items.fold(
        0.0,
            (sum, item) => sum + (item.price * item.qty),
      ),
        total = (subtotal ??
            items.fold(
              0.0,
                  (sum, item) => sum! + (item.price * item.qty),
            ))! -
            discount +
            tax +
            shippingCost;

  /// ✅ copyWith (immutability best practice)
  Order copyWith({
    int? id,
    String? status,
    String? paymentStatus,
    String? paymentMethod,
    double? subtotal,
    double? discount,
    double? tax,
    double? shippingCost,
    double? total,
    List<OrderItem>? items,
    String? customerName,
    String? pickupLocation,
    String? deliveryLocation,
  }) {
    return Order(
      id: id ?? this.id,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      customerName: customerName ?? this.customerName,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
    );
  }
}

class OrderItem {
  final String name;
  final double price;
  final int qty;

  const OrderItem({
    required this.name,
    required this.price,
    required this.qty,
  });
}
