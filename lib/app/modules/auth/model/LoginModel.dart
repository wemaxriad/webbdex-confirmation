class LoginModel {
  Users? users;
  String? token;

  LoginModel({this.users, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    users = json['users'] != null ? Users.fromJson(json['users']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (users != null) {
      data['users'] = users!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class Users {
  int? id;
  String? email;
  String? name;
  String? username;
  int? emailVerified;
  dynamic userType;
  String? accountType;
  String? tenantId;
  dynamic ownerUserId;

  Users({this.id, this.email, this.name, this.username, this.emailVerified, this.userType, this.accountType, this.tenantId, this.ownerUserId});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    username = json['username'];
    emailVerified = json['email_verified'];
    userType = json['user_type'];
    accountType = json['account_type'];
    tenantId = json['tenant_id']?.toString();
    ownerUserId = json['owner_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['username'] = username;
    data['email_verified'] = emailVerified;
    data['user_type'] = userType;
    data['account_type'] = accountType;
    data['tenant_id'] = tenantId;
    data['owner_user_id'] = ownerUserId;
    return data;
  }
}
