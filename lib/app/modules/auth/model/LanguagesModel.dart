class LanguagesModel {
  bool? success;
  List<Languages>? languages;
  String? msg;

  LanguagesModel({this.success, this.languages, this.msg});

  LanguagesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(new Languages.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Languages {
  int? id;
  String? name;
  String? slug;
  int? direction;
  int? status;
  int? defaultStatus;
  String? createdAt;
  String? updatedAt;

  Languages(
      {this.id,
        this.name,
        this.slug,
        this.direction,
        this.status,
        this.defaultStatus,
        this.createdAt,
        this.updatedAt});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    direction = json['direction'];
    status = json['status'];
    defaultStatus = json['default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['direction'] = this.direction;
    data['status'] = this.status;
    data['default'] = this.defaultStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
