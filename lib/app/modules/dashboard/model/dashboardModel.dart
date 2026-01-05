class DashboardModel {
  bool? status;
  DashboardData? data;

  DashboardModel({this.status, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? DashboardData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DashboardData {
  int? totalAssignedOrder;
  int? totalApprovedOrder;
  int? totalCancelOrder;
  List<LastAssignedOrders>? lastAssignedOrders;
  UserDetails? userDetails;

  DashboardData(
      {this.totalAssignedOrder,
        this.totalApprovedOrder,
        this.totalCancelOrder,
        this.lastAssignedOrders,
        this.userDetails});

  DashboardData.fromJson(Map<String, dynamic> json) {
    totalAssignedOrder = json['totalAssignedOrder'];
    totalApprovedOrder = json['totalApprovedOrder'];
    totalCancelOrder = json['totalCancelOrder'];
    if (json['lastAssignedOrders'] != null) {
      lastAssignedOrders = <LastAssignedOrders>[];
      json['lastAssignedOrders'].forEach((v) {
        lastAssignedOrders!.add(new LastAssignedOrders.fromJson(v));
      });
    }
    userDetails = json['userDetails'] != null
        ? new UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalAssignedOrder'] = totalAssignedOrder;
    data['totalApprovedOrder'] = totalApprovedOrder;
    data['totalCancelOrder'] = totalCancelOrder;
    if (lastAssignedOrders != null) {
      data['lastAssignedOrders'] =
          lastAssignedOrders!.map((v) => v.toJson()).toList();
    }
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    return data;
  }
}

class LastAssignedOrders {
  int? id;
  String? name;
  String? email;
  dynamic userId;
  String? phone;
  String? country;
  String? address;
  String? city;
  String? state;
  String? zipcode;
  dynamic message;
  String? coupon;
  String? couponDiscounted;
  String? totalAmount;
  String? status;
  String? paymentStatus;
  String? paymentGateway;
  String? paymentTrack;
  dynamic transactionId;
  String? orderDetails;
  String? paymentMeta;
  dynamic shippingAddressId;
  dynamic selectedShippingOption;
  String? checkoutType;
  dynamic checkoutImagePath;
  String? createdAt;
  String? updatedAt;
  String? tenancyDbName;
  String? fromProductOrderId;
  dynamic affiAdminCommiAmount;
  String? confirmationStatus;
  dynamic confirmationPreferredLanguage;
  String? confirmationDate;
  String? expectedDeliveryDates;
  dynamic confirmationCallNote;
  dynamic confirmationCallRecord;
  dynamic confirmationCallImage;
  String? confirmationUserId;
  String? tenantId;
  dynamic tenantName;
  String? globalId;

  LastAssignedOrders(
      {this.id,
        this.name,
        this.email,
        this.userId,
        this.phone,
        this.country,
        this.address,
        this.city,
        this.state,
        this.zipcode,
        this.message,
        this.coupon,
        this.couponDiscounted,
        this.totalAmount,
        this.status,
        this.paymentStatus,
        this.paymentGateway,
        this.paymentTrack,
        this.transactionId,
        this.orderDetails,
        this.paymentMeta,
        this.shippingAddressId,
        this.selectedShippingOption,
        this.checkoutType,
        this.checkoutImagePath,
        this.createdAt,
        this.updatedAt,
        this.tenancyDbName,
        this.fromProductOrderId,
        this.affiAdminCommiAmount,
        this.confirmationStatus,
        this.confirmationPreferredLanguage,
        this.confirmationDate,
        this.expectedDeliveryDates,
        this.confirmationCallNote,
        this.confirmationCallRecord,
        this.confirmationCallImage,
        this.confirmationUserId,
        this.tenantId,
        this.tenantName,
        this.globalId});

  LastAssignedOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    userId = json['user_id'];
    phone = json['phone'];
    country = json['country'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    message = json['message'];
    coupon = json['coupon'];
    couponDiscounted = json['coupon_discounted'];
    totalAmount = json['total_amount'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    paymentGateway = json['payment_gateway'];
    paymentTrack = json['payment_track'];
    transactionId = json['transaction_id'];
    orderDetails = json['order_details'];
    paymentMeta = json['payment_meta'];
    shippingAddressId = json['shipping_address_id'];
    selectedShippingOption = json['selected_shipping_option'];
    checkoutType = json['checkout_type'];
    checkoutImagePath = json['checkout_image_path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tenancyDbName = json['tenancy_db_name'];
    fromProductOrderId = json['from_product_order_id'];
    affiAdminCommiAmount = json['affi_admin_commi_amount'];
    confirmationStatus = json['confirmation_status'];
    confirmationPreferredLanguage = json['confirmation_preferred_language'];
    confirmationDate = json['confirmation_date'];
    expectedDeliveryDates = json['expected_delivery_dates'];
    confirmationCallNote = json['confirmation_call_note'];
    confirmationCallRecord = json['confirmation_call_record'];
    confirmationCallImage = json['confirmation_call_image'];
    confirmationUserId = json['confirmation_user_id'];
    tenantId = json['tenant_id'];
    tenantName = json['tenant_name'];
    globalId = json['global_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['user_id'] = userId;
    data['phone'] = phone;
    data['country'] = country;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['message'] = message;
    data['coupon'] = coupon;
    data['coupon_discounted'] = couponDiscounted;
    data['total_amount'] = totalAmount;
    data['status'] = status;
    data['payment_status'] = paymentStatus;
    data['payment_gateway'] = paymentGateway;
    data['payment_track'] = paymentTrack;
    data['transaction_id'] = transactionId;
    data['order_details'] = orderDetails;
    data['payment_meta'] = paymentMeta;
    data['shipping_address_id'] = shippingAddressId;
    data['selected_shipping_option'] = selectedShippingOption;
    data['checkout_type'] = checkoutType;
    data['checkout_image_path'] = checkoutImagePath;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['tenancy_db_name'] = tenancyDbName;
    data['from_product_order_id'] = fromProductOrderId;
    data['affi_admin_commi_amount'] = affiAdminCommiAmount;
    data['confirmation_status'] = confirmationStatus;
    data['confirmation_preferred_language'] =
        confirmationPreferredLanguage;
    data['confirmation_date'] = confirmationDate;
    data['expected_delivery_dates'] = expectedDeliveryDates;
    data['confirmation_call_note'] = confirmationCallNote;
    data['confirmation_call_record'] = confirmationCallRecord;
    data['confirmation_call_image'] = confirmationCallImage;
    data['confirmation_user_id'] = confirmationUserId;
    data['tenant_id'] = tenantId;
    data['tenant_name'] = tenantName;
    data['global_id'] = globalId;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['register_id'] = registerId;
    data['nid_number'] = nidNumber;
    data['passport_number'] = passportNumber;
    data['profile_photo'] = profilePhoto;
    data['address'] = address;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['document_type_id'] = documentTypeId;
    data['document_type_name'] = documentTypeName;
    data['file_url'] = fileUrl;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
