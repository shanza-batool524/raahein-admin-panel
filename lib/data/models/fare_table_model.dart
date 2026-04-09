class FareTableResponse {
  RouteInfo? route;
  List<FareTableItem>? fareTable;

  FareTableResponse({this.route, this.fareTable});

  FareTableResponse.fromJson(Map<String, dynamic> json) {
    route = json['route'] != null ? RouteInfo.fromJson(json['route']) : null;
    if (json['fareTable'] != null) {
      fareTable = <FareTableItem>[];
      json['fareTable'].forEach((v) {
        fareTable!.add(FareTableItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (route != null) {
      data['route'] = route!.toJson();
    }
    if (fareTable != null) {
      data['fareTable'] = fareTable!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RouteInfo {
  int? id;
  String? fromCity;
  String? toCity;

  RouteInfo({this.id, this.fromCity, this.toCity});

  RouteInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromCity = json['fromCity'];
    toCity = json['toCity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fromCity'] = fromCity;
    data['toCity'] = toCity;
    return data;
  }
}

class FareTableItem {
  String? vehicleCategory;
  List<FareVariant>? variants;

  FareTableItem({this.vehicleCategory, this.variants});

  FareTableItem.fromJson(Map<String, dynamic> json) {
    vehicleCategory = json['vehicleCategory'];
    if (json['variants'] != null) {
      variants = <FareVariant>[];
      json['variants'].forEach((v) {
        variants!.add(FareVariant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vehicleCategory'] = vehicleCategory;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FareVariant {
  int? passengers;
  bool? hasAC;
  int? fare;

  FareVariant({this.passengers, this.hasAC, this.fare});

  FareVariant.fromJson(Map<String, dynamic> json) {
    passengers = json['passengers'];
    hasAC = json['hasAC'];
    fare = json['fare'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passengers'] = passengers;
    data['hasAC'] = hasAC;
    data['fare'] = fare;
    return data;
  }
}
