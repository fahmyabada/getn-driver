import 'Title.dart';
import 'Desc.dart';
import 'Brief.dart';
import 'Icon.dart';

class CarCategory {
  CarCategory({
      Title? title, 
      Desc? desc, 
      Brief? brief, 
      Icon? icon, 
      String? priceType, 
      bool? status,
      String? createdAt, 
      String? updatedAt, 
      String? id, 
      String? carType,
      String? user,}){
    _title = title;
    _desc = desc;
    _brief = brief;
    _icon = icon;
    _priceType = priceType;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _carType = carType;
    _user = user;
}

  CarCategory.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _desc = json['desc'] != null ? Desc.fromJson(json['desc']) : null;
    _brief = json['brief'] != null ? Brief.fromJson(json['brief']) : null;
    _icon = json['icon'] != null ? Icon.fromJson(json['icon']) : null;
    _priceType = json['priceType'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _carType = json['carType'];
    _user = json['user'];
  }
  Title? _title;
  Desc? _desc;
  Brief? _brief;
  Icon? _icon;
  String? _priceType;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  String? _carType;
  String? _user;

  Title? get title => _title;
  Desc? get desc => _desc;
  Brief? get brief => _brief;
  Icon? get icon => _icon;
  String? get priceType => _priceType;
  bool? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get id => _id;
  String? get carType => _carType;
  String? get user => _user;

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
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['carType'] = _carType;
    map['user'] = _user;
    return map;
  }

}