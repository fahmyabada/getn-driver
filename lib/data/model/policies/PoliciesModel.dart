import 'Name.dart';
import 'Content.dart';

class PoliciesModel {
  PoliciesModel({
      Name? name, 
      Content? content, 
      String? updatedAt, 
      String? createdAt, 
      bool? status, 
      String? id, 
      String? user, 
      String? slug, 
      int? v,}){
    _name = name;
    _content = content;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _status = status;
    _id = id;
    _user = user;
    _slug = slug;
    _v = v;
}

  PoliciesModel.fromJson(dynamic json) {
    _name = json['name'] != null ? Name.fromJson(json['name']) : null;
    _content = json['content'] != null ? Content.fromJson(json['content']) : null;
    _updatedAt = json['updatedAt'];
    _createdAt = json['createdAt'];
    _status = json['status'];
    _id = json['_id'];
    _user = json['user'];
    _slug = json['slug'];
    _v = json['__v'];
  }
  Name? _name;
  Content? _content;
  String? _updatedAt;
  String? _createdAt;
  bool? _status;
  String? _id;
  String? _user;
  String? _slug;
  int? _v;

  Name? get name => _name;
  Content? get content => _content;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  bool? get status => _status;
  String? get id => _id;
  String? get user => _user;
  String? get slug => _slug;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_name != null) {
      map['name'] = _name?.toJson();
    }
    if (_content != null) {
      map['content'] = _content?.toJson();
    }
    map['updatedAt'] = _updatedAt;
    map['createdAt'] = _createdAt;
    map['status'] = _status;
    map['_id'] = _id;
    map['user'] = _user;
    map['slug'] = _slug;
    map['__v'] = _v;
    return map;
  }

}