class CountryModel {
  bool? status;
  List<String>? countries;

  CountryModel({this.status, this.countries});

  CountryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    countries = json['countries'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['countries'] = countries;
    return data;
  }
}
