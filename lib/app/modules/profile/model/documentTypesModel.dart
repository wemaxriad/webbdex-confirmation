class DocumentTypesModel {
  List<DocumentTypes>? documentTypes;

  DocumentTypesModel({this.documentTypes});

  DocumentTypesModel.fromJson(Map<String, dynamic> json) {
    if (json['documentTypes'] != null) {
      documentTypes = <DocumentTypes>[];
      json['documentTypes'].forEach((v) {
        documentTypes!.add(new DocumentTypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documentTypes != null) {
      data['documentTypes'] =
          this.documentTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DocumentTypes {
  int? id;
  String? name;
  String? slug;
  bool? isRequired;
  dynamic createdAt;
  String? updatedAt;

  DocumentTypes(
      {this.id,
        this.name,
        this.slug,
        this.isRequired,
        this.createdAt,
        this.updatedAt});

  DocumentTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    isRequired = json['is_required'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['is_required'] = this.isRequired;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
