class ProfileModel {
  UserDetails? userDetails;

  ProfileModel({this.userDetails});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? username;
  dynamic hasSubdomain;
  dynamic emailVerified;
  String? emailVerifyToken;
  String? mobile;
  String? company;
  String? address;
  String? city;
  dynamic userType;
  String? state;
  String? country;
  dynamic image;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  ConfirmationAgentDetail? confirmationAgentDetail;
  dynamic confirmationAgentStatus;
  List<ConfirmationAgentDocuments>? confirmationAgentDocuments;

  UserDetails(
      {this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.username,
        this.hasSubdomain,
        this.emailVerified,
        this.emailVerifyToken,
        this.mobile,
        this.company,
        this.address,
        this.city,
        this.userType,
        this.state,
        this.country,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.confirmationAgentDetail,
        this.confirmationAgentStatus,
        this.confirmationAgentDocuments});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    username = json['username'];
    hasSubdomain = json['has_subdomain'];
    emailVerified = json['email_verified'];
    emailVerifyToken = json['email_verify_token'];
    mobile = json['mobile'];
    company = json['company'];
    address = json['address'];
    city = json['city'];
    userType = json['user_type'];
    state = json['state'];
    country = json['country'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    confirmationAgentDetail = json['confirmation_agent_detail'] != null
        ? new ConfirmationAgentDetail.fromJson(
        json['confirmation_agent_detail'])
        : null;
    confirmationAgentStatus = json['confirmation_agent_status'];
    if (json['confirmation_agent_documents'] != null) {
      confirmationAgentDocuments = <ConfirmationAgentDocuments>[];
      json['confirmation_agent_documents'].forEach((v) {
        confirmationAgentDocuments!
            .add(new ConfirmationAgentDocuments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['username'] = this.username;
    data['has_subdomain'] = this.hasSubdomain;
    data['email_verified'] = this.emailVerified;
    data['email_verify_token'] = this.emailVerifyToken;
    data['mobile'] = this.mobile;
    data['company'] = this.company;
    data['address'] = this.address;
    data['city'] = this.city;
    data['user_type'] = this.userType;
    data['state'] = this.state;
    data['country'] = this.country;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.confirmationAgentDetail != null) {
      data['confirmation_agent_detail'] =
          this.confirmationAgentDetail!.toJson();
    }
    data['confirmation_agent_status'] = this.confirmationAgentStatus;
    if (this.confirmationAgentDocuments != null) {
      data['confirmation_agent_documents'] =
          this.confirmationAgentDocuments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConfirmationAgentDetail {
  int? id;
  int? userId;
  dynamic registerId;
  String? nidNumber;
  String? passportNumber;
  dynamic profilePhoto;
  dynamic address;
  int? status;
  String? createdAt;
  String? updatedAt;

  ConfirmationAgentDetail(
      {this.id,
        this.userId,
        this.registerId,
        this.nidNumber,
        this.passportNumber,
        this.profilePhoto,
        this.address,
        this.status,
        this.createdAt,
        this.updatedAt});

  ConfirmationAgentDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    registerId = json['register_id'];
    nidNumber = json['nid_number'];
    passportNumber = json['passport_number'];
    profilePhoto = json['profile_photo'];
    address = json['address'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['register_id'] = this.registerId;
    data['nid_number'] = this.nidNumber;
    data['passport_number'] = this.passportNumber;
    data['profile_photo'] = this.profilePhoto;
    data['address'] = this.address;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ConfirmationAgentDocuments {
  int? id;
  int? documentTypeId;
  String? documentTypeName;
  String? fileUrl;
  String? createdAt;
  String? updatedAt;

  ConfirmationAgentDocuments(
      {this.id,
        this.documentTypeId,
        this.documentTypeName,
        this.fileUrl,
        this.createdAt,
        this.updatedAt});

  ConfirmationAgentDocuments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    documentTypeId = json['document_type_id'];
    documentTypeName = json['document_type_name'];
    fileUrl = json['file_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['document_type_id'] = this.documentTypeId;
    data['document_type_name'] = this.documentTypeName;
    data['file_url'] = this.fileUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
