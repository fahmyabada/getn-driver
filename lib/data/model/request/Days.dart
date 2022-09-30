class Days {
  Days({
    String? from,
    String? to,
    String? totalHours,
    String? points,
    String? priceType,
    String? consumptionPoints,
    String? id,
    String? price,
  }) {
    _from = from;
    _to = to;
    _totalHours = totalHours;
    _points = points;
    _priceType = priceType;
    _consumptionPoints = consumptionPoints;
    _id = id;
    _price = price;
  }

  Days.fromJson(dynamic json) {
    _from = json['from'];
    _to = json['to'];
    _totalHours = json['totalHours'].toString();
    _points = json['points'].toString();
    _priceType = json['priceType'];
    _consumptionPoints = json['consumptionPoints'].toString();
    _id = json['_id'];
    _price = json['price'].toString();
  }

  String? _from;
  String? _to;
  String? _totalHours;
  String? _points;
  String? _priceType;
  String? _consumptionPoints;
  String? _id;
  String? _price;

  String? get from => _from;

  String? get to => _to;

  String? get totalHours => _totalHours;

  String? get points => _points;

  String? get priceType => _priceType;

  String? get consumptionPoints => _consumptionPoints;

  String? get id => _id;

  String? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['from'] = _from;
    map['to'] = _to;
    map['totalHours'] = _totalHours;
    map['points'] = _points;
    map['priceType'] = _priceType;
    map['consumptionPoints'] = _consumptionPoints;
    map['_id'] = _id;
    map['price'] = _price;
    return map;
  }
}
