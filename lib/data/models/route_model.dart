class RouteModel {
  int? id;
  String? fromCity;
  String? toCity;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  List<dynamic>? fares;

  RouteModel({
    this.id,
    this.fromCity,
    this.toCity,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.fares,
  });

  RouteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromCity = json['fromCity'];
    toCity = json['toCity'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['fares'] != null) {
      fares = List<dynamic>.from(json['fares']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fromCity'] = fromCity;
    data['toCity'] = toCity;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (fares != null) {
      data['fares'] = fares;
    }
    return data;
  }
}
