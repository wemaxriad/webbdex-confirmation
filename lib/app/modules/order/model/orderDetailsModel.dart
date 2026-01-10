class OrderDetailsModel {
  bool? status;
  String? msg;
  Order? order;

  OrderDetailsModel({this.status, this.msg, this.order});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? id;
  String? tenantId;
  String? globalId;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? customerAddress;
  List<OrderItem>? orderDetails;
  String? orderNote;
  String? totalAmount;
  String? subtotal;
  String? productTax;
  String? shippingCost;
  String? confirmationCallNote;
  String? confirmationCallRecord;
  String? confirmationCallImage;
  String? confirmationPreferredLanguage;
  String? confirmationStatus;
  String? confirmationStatusName;
  String? status;
  String? statusName;
  String? paymentStatus;
  String? confirmationDate;
  String? createdAt;

  Order(
      {this.id,
        this.tenantId,
        this.globalId,
        this.customerName,
        this.customerPhone,
        this.customerEmail,
        this.customerAddress,
        this.orderDetails,
        this.orderNote,
        this.totalAmount,
        this.subtotal,
        this.productTax,
        this.shippingCost,
        this.confirmationCallNote,
        this.confirmationCallRecord,
        this.confirmationCallImage,
        this.confirmationPreferredLanguage,
        this.confirmationStatus,
        this.confirmationStatusName,
        this.status,
        this.statusName,
        this.paymentStatus,
        this.confirmationDate,
        this.createdAt});

  Order.fromJson(Map<String, dynamic> json) {

    final detailsMap = json['order_details'] as Map<String, dynamic>;

    id = json['id'];
    tenantId = json['tenant_id'];
    globalId = json['global_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];
    customerAddress = json['customer_address'];
    orderDetails = detailsMap.values
        .map((e) => OrderItem.fromJson(e))
        .toList();
    orderNote = json['order_note'];
    totalAmount = json['total_amount'];
    subtotal = json['subtotal'];
    productTax = json['product_tax'];
    shippingCost = json['shipping_cost'];
    confirmationCallNote = json['confirmation_call_note'];
    confirmationCallRecord = json['confirmation_call_record'];
    confirmationCallImage = json['confirmation_call_image'];
    confirmationPreferredLanguage = json['confirmation_preferred_language'];
    confirmationStatus = json['confirmation_status'];
    confirmationStatusName = json['confirmation_status_name'];
    status = json['status'];
    statusName = json['status_name'];
    paymentStatus = json['payment_status'];
    confirmationDate = json['confirmation_date'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tenant_id'] = this.tenantId;
    data['global_id'] = this.globalId;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['customer_address'] = this.customerAddress;
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails;
    }
    data['order_note'] = this.orderNote;
    data['total_amount'] = this.totalAmount;
    data['subtotal'] = this.subtotal;
    data['product_tax'] = this.productTax;
    data['shipping_cost'] = this.shippingCost;
    data['confirmation_call_note'] = this.confirmationCallNote;
    data['confirmation_call_record'] = this.confirmationCallRecord;
    data['confirmation_call_image'] = this.confirmationCallImage;
    data['confirmation_preferred_language'] =
        this.confirmationPreferredLanguage;
    data['confirmation_status'] = this.confirmationStatus;
    data['confirmation_status_name'] = this.confirmationStatusName;
    data['status'] = this.status;
    data['status_name'] = this.statusName;
    data['payment_status'] = this.paymentStatus;
    data['confirmation_date'] = this.confirmationDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class OrderItem {
  final String name;
  final String qty;
  final num price;
  final num subtotal;

  OrderItem({
    required this.name,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['name'],
      qty: json['qty'],
      price: json['price'],
      subtotal: json['subtotal'],
    );
  }
}



class UsedCategories {
  int? category;
  int? subcategory;

  UsedCategories({this.category, this.subcategory});

  UsedCategories.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    subcategory = json['subcategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    return data;
  }
}
