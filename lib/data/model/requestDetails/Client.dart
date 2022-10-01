import 'package:getn_driver/data/model/signModel/Country.dart';

import 'Area.dart';
import 'City.dart';

class Client {
  Client({
      dynamic image,
      String? id,
      Country? country,
      String? name,
      Area? area,
      City? city,}){
    _image = image;
    _id = id;
    _country = country;
    _name = name;
    _area = area;
    _city = city;
}

  Client.fromJson(dynamic json) {
    _image = json['image'] ?? "";
    _id = json['_id'];
    _country = json['country'] != null ? Country.fromJson(json['country']) : null;
    _name = json['name'];
    _area = json['area'] != null ? Area.fromJson(json['area']) : null;
    _city = json['city'] != null ? City.fromJson(json['city']) : null;
  }
  dynamic _image;
  String? _id;
  Country? _country;
  String? _name;
  Area? _area;
  City? _city;

  dynamic get image => _image;
  String? get id => _id;
  Country? get country => _country;
  String? get name => _name;
  Area? get area => _area;
  City? get city => _city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = _image;
    map['_id'] = _id;
    if (_country != null) {
      map['country'] = _country?.toJson();
    }
    map['name'] = _name;
    if (_area != null) {
      map['area'] = _area?.toJson();
    }
    if (_city != null) {
      map['city'] = _city?.toJson();
    }
    return map;
  }

}