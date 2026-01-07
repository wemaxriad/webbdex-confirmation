class WalletHistoryModel {
  bool? status;
  WalletData? data;

  WalletHistoryModel({this.status, this.data});

  WalletHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new WalletData.fromJson(json['data']) : null;
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

class WalletData {
  String? totalBalance;
  String? totalWithdrawPending;
  String? totalWithdrawPaid;

  WalletData({this.totalBalance, this.totalWithdrawPending, this.totalWithdrawPaid});

  WalletData.fromJson(Map<String, dynamic> json) {
    totalBalance = json['totalBalance'];
    totalWithdrawPending = json['totalWithdrawPending'];
    totalWithdrawPaid = json['totalWithdrawPaid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalBalance'] = this.totalBalance;
    data['totalWithdrawPending'] = this.totalWithdrawPending;
    data['totalWithdrawPaid'] = this.totalWithdrawPaid;
    return data;
  }
}
