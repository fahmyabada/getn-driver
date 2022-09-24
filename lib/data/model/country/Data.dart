import 'Title.dart';
import 'IconModel.dart';
import 'User.dart';

class Data {
  Data({
      Title? title, 
      IconModel? icon,
      bool? status, 
      String? createdAt, 
      String? updatedAt, 
      String? id, 
      String? zip, 
      String? code, 
      User? user, 
      int? v,}){
    _title = title;
    _icon = icon;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _zip = zip;
    _code = code;
    _user = user;
    _v = v;
}

  Data.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _icon = json['icon'] != null ? IconModel.fromJson(json['icon']) : null;
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _zip = json['zip'];
    _code = json['code'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _v = json['__v'];
  }
  Title? _title;
  IconModel? _icon;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  String? _zip;
  String? _code;
  User? _user;
  int? _v;

  Title? get title => _title;
  IconModel? get icon => _icon;
  bool? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get id => _id;
  String? get zip => _zip;
  String? get code => _code;
  User? get user => _user;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    if (_icon != null) {
      map['icon'] = _icon?.toJson();
    }
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['zip'] = _zip;
    map['code'] = _code;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['__v'] = _v;
    return map;
  }

}