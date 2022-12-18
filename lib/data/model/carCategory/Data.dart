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
    bool? status,
    String? createdAt,
    String? updatedAt,
    String? id,
    String? carType,
    String? code,
  }) {
    _title = title;
    _desc = desc;
    _brief = brief;
    _icon = icon;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _carType = carType;
    _code = code;
  }

  Data.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _desc = json['desc'] != null ? Desc.fromJson(json['desc']) : null;
    _brief = json['brief'] != null ? Brief.fromJson(json['brief']) : null;
    _icon = json['icon'] != null ? Icon.fromJson(json['icon']) : null;
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _carType = json['carType'];
    _code = json['code'];
  }

  Title? _title;
  Desc? _desc;
  Brief? _brief;
  Icon? _icon;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  String? _carType;
  String? _code;

  Title? get title => _title;

  Desc? get desc => _desc;

  Brief? get brief => _brief;

  Icon? get icon => _icon;

  bool? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get id => _id;

  String? get carType => _carType;

  String? get code => _code;



  @override
  String toString() {
    return 'Data{_title: $_title, _desc: $_desc, _brief: $_brief, _icon: $_icon _status: $_status, _createdAt: $_createdAt, _updatedAt: $_updatedAt, _id: $_id, _carType: $_carType, _code: $_code}';
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
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['carType'] = _carType;
    map['code'] = _code;
    return map;
  }
}
