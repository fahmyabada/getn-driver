import 'Brief.dart';
import 'Desc.dart';
import 'Icon.dart';
import 'Title.dart';

class Data {
  Data({
    Title? title,
    Desc? desc,
    Brief? brief,
    Icon? icon,
    String? priceType,
    int? oneKMPoints,
    bool? status,
    String? createdAt,
    String? updatedAt,
    String? id,
    int? oneKMCoins,
    String? carType,
    String? code,
    int? price,
    int? coins,
    int? seq,
    String? user,
    int? v,
    int? points,
  }) {
    _title = title;
    _desc = desc;
    _brief = brief;
    _icon = icon;
    _priceType = priceType;
    _oneKMPoints = oneKMPoints;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _oneKMCoins = oneKMCoins;
    _carType = carType;
    _code = code;
    _price = price;
    _coins = coins;
    _seq = seq;
    _user = user;
    _v = v;
    _points = points;
  }

  Data.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _desc = json['desc'] != null ? Desc.fromJson(json['desc']) : null;
    _brief = json['brief'] != null ? Brief.fromJson(json['brief']) : null;
    _icon = json['icon'] != null ? Icon.fromJson(json['icon']) : null;
    _priceType = json['priceType'];
    _oneKMPoints = json['oneKMPoints'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _oneKMCoins = json['oneKMCoins'];
    _carType = json['carType'];
    _code = json['code'];
    _price = json['price'];
    _coins = json['coins'];
    _seq = json['seq'];
    _user = json['user'] is! String ? "" : json['user'];
    _v = json['__v'];
    _points = json['points'];
  }

  Title? _title;
  Desc? _desc;
  Brief? _brief;
  Icon? _icon;
  String? _priceType;
  int? _oneKMPoints;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  int? _oneKMCoins;
  String? _carType;
  String? _code;
  int? _price;
  int? _coins;
  int? _seq;
  String? _user;
  int? _v;
  int? _points;

  Title? get title => _title;

  Desc? get desc => _desc;

  Brief? get brief => _brief;

  Icon? get icon => _icon;

  String? get priceType => _priceType;

  int? get oneKMPoints => _oneKMPoints;

  bool? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get id => _id;

  int? get oneKMCoins => _oneKMCoins;

  String? get carType => _carType;

  String? get code => _code;

  int? get price => _price;

  int? get coins => _coins;

  int? get seq => _seq;

  String? get user => _user;

  int? get v => _v;

  int? get points => _points;

  @override
  String toString() {
    return 'Data{_title: $_title, _desc: $_desc, _brief: $_brief, _icon: $_icon, _priceType: $_priceType, _oneKMPoints: $_oneKMPoints, _status: $_status, _createdAt: $_createdAt, _updatedAt: $_updatedAt, _id: $_id, _oneKMCoins: $_oneKMCoins, _carType: $_carType, _code: $_code, _price: $_price, _coins: $_coins, _seq: $_seq, _user: $_user, _v: $_v, _points: $_points}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    if (_desc != null) {
      map['desc'] = _desc?.toJson();
    }
    if (_brief != null) {
      map['brief'] = _brief?.toJson();
    }
    if (_icon != null) {
      map['icon'] = _icon?.toJson();
    }
    map['priceType'] = _priceType;
    map['oneKMPoints'] = _oneKMPoints;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['oneKMCoins'] = _oneKMCoins;
    map['carType'] = _carType;
    map['code'] = _code;
    map['price'] = _price;
    map['coins'] = _coins;
    map['seq'] = _seq;
    map['user'] = _user;
    map['__v'] = _v;
    map['points'] = _points;
    return map;
  }
}
