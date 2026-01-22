class OrderListModel {
  bool? status;
  String? msg;
  OrderData? data;

  OrderListModel({this.status, this.msg, this.data});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new OrderData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class OrderData {
  List<OrderList>? orderList;
  int? currentPage;
  int? lastPage;

  OrderData({this.orderList, this.currentPage, this.lastPage});

  OrderData.fromJson(Map<String, dynamic> json) {
    if (json['order_list'] != null) {
      orderList = <OrderList>[];
      json['order_list'].forEach((v) {
        orderList!.add(new OrderList.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['order_list'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class OrderList {
  int? id;
  String? tenantId;
  String? globalId;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? totalAmount;
  String? confirmationStatus;
  String? confirmationStatusName;
  String? confirmationPreferredLanguage;
  String? status;
  String? statusName;
  String? paymentStatus;
  String? createdAt;

  OrderList(
      {this.id,
        this.tenantId,
        this.globalId,
        this.customerName,
        this.customerPhone,
        this.customerEmail,
        this.totalAmount,
        this.confirmationStatus,
        this.confirmationStatusName,
        this.confirmationPreferredLanguage,
        this.status,
        this.statusName,
        this.paymentStatus,
        this.createdAt});

  OrderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenant_id'];
    globalId = json['global_id'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    customerEmail = json['customer_email'];
    totalAmount = json['total_amount'];
    confirmationStatus = json['confirmation_status'];
    confirmationStatusName = json['confirmation_status_name'];
    confirmationPreferredLanguage = json['confirmation_preferred_language'];
    status = json['status'];
    statusName = json['status_name'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['tenant_id'] = this.tenantId;
    data['global_id'] = this.globalId;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['total_amount'] = this.totalAmount;
    data['confirmation_status'] = this.confirmationStatus;
    data['confirmation_status_name'] = this.confirmationStatusName;
    data['confirmation_preferred_language'] =
        this.confirmationPreferredLanguage;
    data['status'] = this.status;
    data['status_name'] = this.statusName;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    return data;
  }
}
