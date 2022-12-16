class CurrentDayRequest {
  CurrentDayRequest({
    String? from,
    String? to,
    double? points,
    String? priceType,
    double? consumptionPoints,
    double? consumptionKM,
    double? extraPoints,
    double? extraKM,
    String? id,
    double? price,
  }) {
    _from = from;
    _to = to;
    _points = points;
    _priceType = priceType;
    _consumptionPoints = consumptionPoints;
    _consumptionKM = consumptionKM;
    _extraPoints = extraPoints;
    _extraKM = extraKM;
    _id = id;
    _price = price;
  }

  CurrentDayRequest.fromJson(dynamic json) {
    _from = json['from'];
    _to = json['to'];
    _points = double.parse(json['points'].toString());
    _priceType = json['priceType'];
    _consumptionPoints = double.parse(json['consumptionPoints'].toString());
    _consumptionKM = double.parse(json['consumptionKM'].toString());
    _extraPoints = double.parse(json['extraPoints'].toString());
    _extraKM = double.parse(json['extraKM'].toString());
    _id = json['_id'];
    _price = double.parse(json['price'].toString());
  }

  String? _from;
  String? _to;
  double? _points;
  String? _priceType;
  double? _consumptionPoints;
  double? _consumptionKM;
  double? _extraPoints;
  double? _extraKM;
  String? _id;
  double? _price;

  String? get from => _from;

  String? get to => _to;

  double? get points => _points;

  String? get priceType => _priceType;

  double? get consumptionPoints => _consumptionPoints;

  double? get consumptionKM => _consumptionKM;

  double? get extraPoints => _extraPoints;

  double? get extraKM => _extraKM;

  String? get id => _id;

  double? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['from'] = _from;
    map['to'] = _to;
    map['points'] = _points;
    map['priceType'] = _priceType;
    map['consumptionPoints'] = _consumptionPoints;
    map['consumptionKM'] = _consumptionKM;
    map['extraPoints'] = _extraPoints;
    map['extraKM'] = _extraKM;
    map['_id'] = _id;
    map['price'] = _price;
    return map;
  }
}
