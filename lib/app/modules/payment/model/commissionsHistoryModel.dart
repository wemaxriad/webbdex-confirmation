class CommissionsHistoryModel {
  bool? status;
  Data? data;

  CommissionsHistoryModel({this.status, this.data});

  CommissionsHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<CommissionsHistory>? commissionsHistory;
  String? totalCommissionAmount;

  Data({this.commissionsHistory, this.totalCommissionAmount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['commissions_history'] != null) {
      commissionsHistory = <CommissionsHistory>[];
      json['commissions_history'].forEach((v) {
        commissionsHistory!.add(new CommissionsHistory.fromJson(v));
      });
    }
    totalCommissionAmount = json['total_commission_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commissionsHistory != null) {
      data['commissions_history'] =
          this.commissionsHistory!.map((v) => v.toJson()).toList();
    }
    data['total_commission_amount'] = this.totalCommissionAmount;
    return data;
  }
}

class CommissionsHistory {
  int? id;
  String? tenantId;
  String? productOrderId;
  String? commissionAmount;
  String? createdAt;

  CommissionsHistory(
      {this.id,
        this.tenantId,
        this.productOrderId,
        this.commissionAmount,
        this.createdAt});

  CommissionsHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenant_id'];
    productOrderId = json['product_order_id'];
    commissionAmount = json['commission_amount'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tenant_id'] = this.tenantId;
    data['product_order_id'] = this.productOrderId;
    data['commission_amount'] = this.commissionAmount;
    data['created_at'] = this.createdAt;
    return data;
  }
}
