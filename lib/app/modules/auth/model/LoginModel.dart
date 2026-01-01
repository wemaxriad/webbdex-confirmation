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
  int? emailVerified;

  Users({this.id, this.email, this.emailVerified});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    emailVerified = json['email_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['email_verified'] = emailVerified;
    return data;
  }
}
