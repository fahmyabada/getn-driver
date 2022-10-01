import 'Title.dart';

class City {
  City({
      Title? title, 
      int? seq, 
      bool? status, 
      String? creatdAt, 
      String? updatedAt, 
      String? id, 
      String? country, 
      String? zip, 
      String? user, 
      int? v,}){
    _title = title;
    _seq = seq;
    _status = status;
    _creatdAt = creatdAt;
    _updatedAt = updatedAt;
    _id = id;
    _country = country;
    _zip = zip;
    _user = user;
    _v = v;
}

  City.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _seq = json['seq'];
    _status = json['status'];
    _creatdAt = json['creatdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _country = json['country'];
    _zip = json['zip'];
    _user = json['user'];
    _v = json['__v'];
  }
  Title? _title;
  int? _seq;
  bool? _status;
  String? _creatdAt;
  String? _updatedAt;
  String? _id;
  String? _country;
  String? _zip;
  String? _user;
  int? _v;

  Title? get title => _title;
  int? get seq => _seq;
  bool? get status => _status;
  String? get creatdAt => _creatdAt;
  String? get updatedAt => _updatedAt;
  String? get id => _id;
  String? get country => _country;
  String? get zip => _zip;
  String? get user => _user;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    map['seq'] = _seq;
    map['status'] = _status;
    map['creatdAt'] = _creatdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['country'] = _country;
    map['zip'] = _zip;
    map['user'] = _user;
    map['__v'] = _v;
    return map;
  }

}