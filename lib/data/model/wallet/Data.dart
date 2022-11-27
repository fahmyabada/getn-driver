import 'PaymentDetails.dart';

class Data {
  Data({
    PaymentDetails? paymentDetails,
    String? user,
    String? type,
    String? status,
    String? paymentMethod,
    double? amount,
    String? createdAt,
    String? updatedAt,
    String? id,
    int? phone,
    String? country,
    String? driver,
    String? comment,
  }) {
    _paymentDetails = paymentDetails;
    _user = user;
    _type = type;
    _status = status;
    _paymentMethod = paymentMethod;
    _amount = amount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _phone = phone;
    _country = country;
    _driver = driver;
    _comment = comment;
  }

  Data.fromJson(dynamic json) {
    _paymentDetails = json['paymentDetails'] != null
        ? PaymentDetails.fromJson(json['paymentDetails'])
        : null;
    _user = json['user'];
    _type = json['type'];
    _status = json['status'];
    _paymentMethod = json['paymentMethod'];
    _amount = json['amount'] is int
        ? double.parse(json['amount'].toString())
        : json['amount'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _phone = json['phone'];
    _country = json['country'];
    _driver = json['driver'];
    _comment = json['comment'];
  }

  PaymentDetails? _paymentDetails;
  String? _user;
  String? _type;
  String? _status;
  String? _paymentMethod;
  double? _amount;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  int? _phone;
  String? _country;
  String? _driver;
  String? _comment;

  PaymentDetails? get paymentDetails => _paymentDetails;

  String? get user => _user;

  String? get type => _type;

  String? get status => _status;

  String? get paymentMethod => _paymentMethod;

  double? get amount => _amount;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get id => _id;

  int? get phone => _phone;

  String? get country => _country;

  String? get driver => _driver;

  String? get comment => _comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_paymentDetails != null) {
      map['paymentDetails'] = _paymentDetails?.toJson();
    }
    map['user'] = _user;
    map['type'] = _type;
    map['status'] = _status;
    map['paymentMethod'] = _paymentMethod;
    map['amount'] = _amount;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['phone'] = _phone;
    map['country'] = _country;
    map['driver'] = _driver;
    map['comment'] = _comment;
    return map;
  }
}
