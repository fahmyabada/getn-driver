import 'Title.dart';
import 'Desc.dart';
import 'Brief.dart';
import 'Icon.dart';

class Data {
  Data({
      Title? title, 
      Desc? desc, 
      Brief? brief, 
      Icon? icon, 
      int? oneKMPoints, 
      bool? status, 
      String? createdAt, 
      String? updatedAt, 
      String? id, 
      String? priceType, 
      int? price, 
      int? points, 
      int? seq, 
      String? user, 
      int? v, 
      String? carCategory, 
      String? carType,}){
    _title = title;
    _desc = desc;
    _brief = brief;
    _icon = icon;
    _oneKMPoints = oneKMPoints;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _priceType = priceType;
    _price = price;
    _points = points;
    _seq = seq;
    _user = user;
    _v = v;
    _carCategory = carCategory;
    _carType = carType;
}

  Data.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _desc = json['desc'] != null ? Desc.fromJson(json['desc']) : null;
    _brief = json['brief'] != null ? Brief.fromJson(json['brief']) : null;
    _icon = json['icon'] != null ? Icon.fromJson(json['icon']) : null;
    _oneKMPoints = json['oneKMPoints'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _priceType = json['priceType'];
    _price = json['price'];
    _points = json['points'];
    _seq = json['seq'];
    _user = json['user'];
    _v = json['__v'];
    _carCategory = json['carCategory'];
    _carType = json['carType'];
  }
  Title? _title;
  Desc? _desc;
  Brief? _brief;
  Icon? _icon;
  int? _oneKMPoints;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  String? _priceType;
  int? _price;
  int? _points;
  int? _seq;
  String? _user;
  int? _v;
  String? _carCategory;
  String? _carType;

  Title? get title => _title;
  Desc? get desc => _desc;
  Brief? get brief => _brief;
  Icon? get icon => _icon;
  int? get oneKMPoints => _oneKMPoints;
  bool? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get id => _id;
  String? get priceType => _priceType;
  int? get price => _price;
  int? get points => _points;
  int? get seq => _seq;
  String? get user => _user;
  int? get v => _v;
  String? get carCategory => _carCategory;
  String? get carType => _carType;

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
    map['oneKMPoints'] = _oneKMPoints;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['priceType'] = _priceType;
    map['price'] = _price;
    map['points'] = _points;
    map['seq'] = _seq;
    map['user'] = _user;
    map['__v'] = _v;
    map['carCategory'] = _carCategory;
    map['carType'] = _carType;
    return map;
  }

}