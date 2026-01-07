class WithdrawRequestModel {
  bool? status;
  WithdrawHistoryData? data;

  WithdrawRequestModel({this.status, this.data});

  WithdrawRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new WithdrawHistoryData.fromJson(json['data']) : null;
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

class WithdrawHistoryData {
  String? totalBalance;
  String? totalWithdrawPending;
  String? totalWithdrawPaid;
  int? currentPage;
  int? lastPage;
  List<WithdrawRequests>? withdrawRequests;

  WithdrawHistoryData(
      {this.totalBalance,
        this.totalWithdrawPending,
        this.totalWithdrawPaid,
        this.currentPage,
        this.lastPage,
        this.withdrawRequests});

  WithdrawHistoryData.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    totalWithdrawPending = json['totalWithdrawPending'];
    totalWithdrawPaid = json['totalWithdrawPaid'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    if (json['withdrawRequests'] != null) {
      withdrawRequests = <WithdrawRequests>[];
      json['withdrawRequests'].forEach((v) {
        withdrawRequests!.add(new WithdrawRequests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalBalance'] = this.totalBalance;
    data['totalWithdrawPending'] = this.totalWithdrawPending;
    data['totalWithdrawPaid'] = this.totalWithdrawPaid;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    if (this.withdrawRequests != null) {
      data['withdrawRequests'] =
          this.withdrawRequests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WithdrawRequests {
  int? id;
  String? transactionId;
  String? status;
  String? statusName;
  String? requestNote;
  String? amount;
  String? createdAt;
  String? paidAt;

  WithdrawRequests(
      {this.id,
        this.transactionId,
        this.status,
        this.statusName,
        this.requestNote,
        this.amount,
        this.createdAt,
        this.paidAt});

  WithdrawRequests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    status = json['status'];
    statusName = json['status_name'];
    requestNote = json['request_note'];
    amount = json['amount'];
    createdAt = json['created_at'];
    paidAt = json['paid_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['status'] = this.status;
    data['status_name'] = this.statusName;
    data['request_note'] = this.requestNote;
    data['amount'] = this.amount;
    data['created_at'] = this.createdAt;
    data['paid_at'] = this.paidAt;
    return data;
  }
}
