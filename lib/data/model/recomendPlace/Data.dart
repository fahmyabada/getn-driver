import 'package:getn_driver/data/model/signModel/Country.dart';

import 'Address.dart';
import 'Banner.dart';
import 'Brief.dart';
import 'Desc.dart';
import 'Gallery.dart';
import 'Logo.dart';
import 'Title.dart';

class Data {
  Data({
    Brief? brief,
    Address? address,
    Country? area,
    Country? city,
    Country? country,
    Banner? banner,
    Desc? desc,
    Logo? logo,
    Title? title,
    bool? status,
    String? updatedAt,
    List<String>? categories,
    String? createdAt,
    int? branchesCount,
    String? id,
    String? owner,
    double? placeLongitude,
    double? placeLatitude,
    String? place,
    String? user,
    List<Gallery>? gallery,
  }) {
    _brief = brief;
    _address = address;
    _area = area;
    _city = city;
    _country = country;
    _banner = banner;
    _desc = desc;
    _logo = logo;
    _title = title;
    _status = status;
    _updatedAt = updatedAt;
    _categories = categories;
    _createdAt = createdAt;
    _branchesCount = branchesCount;
    _id = id;
    _owner = owner;
    _placeLongitude = placeLongitude;
    _placeLatitude = placeLatitude;
    _user = user;
    _place = place;
    _gallery = gallery;
  }

  Data.fromJson(dynamic json) {
    _brief = json['brief'] != null ? Brief.fromJson(json['brief']) : null;
    _address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    _banner = json['banner'] != null ? Banner.fromJson(json['banner']) : null;
    _desc = json['desc'] != null ? Desc.fromJson(json['desc']) : null;
    _logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
    _image = json['image'] != null ? Logo.fromJson(json['image']) : null;
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _status = json['status'];
    _updatedAt = json['updatedAt'];
    _categories =
        json['categories'] != null ? json['categories'].cast<String>() : [];
    _createdAt = json['createdAt'];
    _branchesCount = json['branchesCount'];

    _id = json['_id'];
    _city = json['city'] != null ? Country.fromJson(json['city']) : null;
    _country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    _area = json['area'] != null ? Country.fromJson(json['area']) : null;
    _owner = json['owner'];
    _owner = json['owner'];
    _place = json['place'];
    _placeLatitude = double.parse(json['placeLatitude'].toString());
    _placeLongitude = double.parse(json['placeLongitude'].toString());
    _user = json['user'];
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
  }

  Brief? _brief;
  Address? _address;
  Banner? _banner;
  Desc? _desc;
  Logo? _logo;
  Logo? _image;
  Title? _title;
  bool? _status;
  String? _updatedAt;
  List<String>? _categories;
  String? _createdAt;
  String? _place;
  int? _branchesCount;
  String? _id;
  String? _owner;
  Country? _city;
  Country? _area;
  Country? _country;
  double? _placeLongitude;
  double? _placeLatitude;
  String? _user;
  List<Gallery>? _gallery;

  Brief? get brief => _brief;

  Address? get address => _address;

  Banner? get banner => _banner;

  Desc? get desc => _desc;

  Logo? get logo => _logo;

  Logo? get image => _image;

  Title? get title => _title;

  bool? get status => _status;

  String? get updatedAt => _updatedAt;

  String? get place => _place;

  List<String>? get categories => _categories;

  String? get createdAt => _createdAt;

  int? get branchesCount => _branchesCount;

  String? get id => _id;

  Country? get city => _city;

  Country? get area => _area;

  Country? get country => _country;

  String? get owner => _owner;

  double? get placeLongitude => _placeLongitude;

  double? get placeLatitude => _placeLatitude;

  String? get user => _user;

  List<Gallery>? get gallery => _gallery;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_brief != null) {
      map['brief'] = _brief?.toJson();
    }
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    if (_area != null) {
      map['area'] = _area?.toJson();
    }
    if (_city != null) {
      map['city'] = _city?.toJson();
    }
    if (_country != null) {
      map['country'] = _country?.toJson();
    }
    if (_banner != null) {
      map['banner'] = _banner?.toJson();
    }
    if (_desc != null) {
      map['desc'] = _desc?.toJson();
    }
    if (_logo != null) {
      map['logo'] = _logo?.toJson();
    }
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    map['status'] = _status;
    map['updatedAt'] = _updatedAt;
    map['categories'] = _categories;
    map['createdAt'] = _createdAt;
    map['branchesCount'] = _branchesCount;

    map['_id'] = _id;
    map['owner'] = _owner;
    map['placeLongitude'] = _placeLongitude;
    map['placeLatitude'] = _placeLatitude;
    map['user'] = _user;
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
