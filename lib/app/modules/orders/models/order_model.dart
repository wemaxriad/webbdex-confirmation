class OrderModel {
  String orderId;
  String status;
  String customerName;
  String totalAmount;
  String date;
  String orderType;
  String paymentStatus;
  String trackingNumber;
  String carrier;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.customerName,
    required this.totalAmount,
    required this.date,
    required this.orderType,
    required this.paymentStatus,
    required this.trackingNumber,
    required this.carrier,
  });
}
