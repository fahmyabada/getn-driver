import 'Title.dart';

class CarColor {
  CarColor({
      Title? title, 
      String? updatedAt, 
      bool? status, 
      String? createdAt, 
      String? id, 
      String? code, 
      String? user, 
      int? v,}){
    _title = title;
    _updatedAt = updatedAt;
    _status = status;
    _createdAt = createdAt;
    _id = id;
    _code = code;
    _user = user;
    _v = v;
}

  CarColor.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _id = json['_id'];
    _code = json['code'];
    _user = json['user'];
    _v = json['__v'];
  }
  Title? _title;
  String? _updatedAt;
  bool? _status;
  String? _createdAt;
  String? _id;
  String? _code;
  String? _user;
  int? _v;

  Title? get title => _title;
  String? get updatedAt => _updatedAt;
  bool? get status => _status;
  String? get createdAt => _createdAt;
  String? get id => _id;
  String? get code => _code;
  String? get user => _user;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['_id'] = _id;
    map['code'] = _code;
    map['user'] = _user;
    map['__v'] = _v;
    return map;
  }

}