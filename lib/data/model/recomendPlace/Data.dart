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
    Banner? banner,
    Desc? desc,
    Logo? logo,
    Title? title,
    int? seq,
    bool? status,
    String? updatedAt,
    List<String>? categories,
    String? createdAt,
    int? visits,
    int? branchesCount,
    int? totalRatings,
    int? ratingsCount,
    int? ratingsAverage,
    int? totalExpectedRatings,
    String? id,
    String? owner,
    String? placeLongitude,
    String? placeLatitude,
    String? place,
    String? user,
    List<Gallery>? gallery,
    int? v,
  }) {
    _brief = brief;
    _address = address;
    _banner = banner;
    _desc = desc;
    _logo = logo;
    _title = title;
    _seq = seq;
    _status = status;
    _updatedAt = updatedAt;
    _categories = categories;
    _createdAt = createdAt;
    _visits = visits;
    _branchesCount = branchesCount;
    _totalRatings = totalRatings;
    _ratingsCount = ratingsCount;
    _ratingsAverage = ratingsAverage;
    _totalExpectedRatings = totalExpectedRatings;
    _id = id;
    _owner = owner;
    _placeLongitude = placeLongitude;
    _placeLatitude = placeLatitude;
    _user = user;
    _place = place;
    _gallery = gallery;
    _v = v;
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
    _seq = json['seq'];
    _status = json['status'];
    _updatedAt = json['updatedAt'];
    _categories =
        json['categories'] != null ? json['categories'].cast<String>() : [];
    _createdAt = json['createdAt'];
    _visits = json['visits'];
    _branchesCount = json['branchesCount'];
    _totalRatings = json['totalRatings'];
    _ratingsCount = json['ratingsCount'];
    _ratingsAverage = json['ratingsAverage'];
    _totalExpectedRatings = json['totalExpectedRatings'];
    _id = json['_id'];
    _city = json['city'];
    _country = json['country'];
    _area = json['area'];
    _owner = json['owner'];
    _owner = json['owner'];
    _place = json['place'];
    _placeLatitude = json['placeLatitude'];
    _placeLongitude = json['placeLongitude'];
    _user = json['user'];
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
    _v = json['__v'];
  }

  Brief? _brief;
  Address? _address;
  Banner? _banner;
  Desc? _desc;
  Logo? _logo;
  Logo? _image;
  Title? _title;
  int? _seq;
  bool? _status;
  String? _updatedAt;
  List<String>? _categories;
  String? _createdAt;
  String? _place;
  int? _visits;
  int? _branchesCount;
  int? _totalRatings;
  int? _ratingsCount;
  int? _ratingsAverage;
  int? _totalExpectedRatings;
  String? _id;
  String? _owner;
  String? _city;
  String? _area;
  String? _country;
  String? _placeLongitude;
  String? _placeLatitude;
  String? _user;
  List<Gallery>? _gallery;
  int? _v;

  Brief? get brief => _brief;

  Address? get address => _address;

  Banner? get banner => _banner;

  Desc? get desc => _desc;

  Logo? get logo => _logo;

  Logo? get image => _image;

  Title? get title => _title;

  int? get seq => _seq;

  bool? get status => _status;

  String? get updatedAt => _updatedAt;

  String? get place => _place;

  List<String>? get categories => _categories;

  String? get createdAt => _createdAt;

  int? get visits => _visits;

  int? get branchesCount => _branchesCount;

  int? get totalRatings => _totalRatings;

  int? get ratingsCount => _ratingsCount;

  int? get ratingsAverage => _ratingsAverage;

  int? get totalExpectedRatings => _totalExpectedRatings;

  String? get id => _id;

  String? get city => _city;

  String? get area => _area;

  String? get country => _country;

  String? get owner => _owner;

  String? get placeLongitude => _placeLongitude;

  String? get placeLatitude => _placeLatitude;

  String? get user => _user;

  List<Gallery>? get gallery => _gallery;

  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_brief != null) {
      map['brief'] = _brief?.toJson();
    }
    if (_address != null) {
      map['address'] = _address?.toJson();
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
    map['seq'] = _seq;
    map['status'] = _status;
    map['updatedAt'] = _updatedAt;
    map['categories'] = _categories;
    map['createdAt'] = _createdAt;
    map['visits'] = _visits;
    map['branchesCount'] = _branchesCount;
    map['totalRatings'] = _totalRatings;
    map['ratingsCount'] = _ratingsCount;
    map['ratingsAverage'] = _ratingsAverage;
    map['totalExpectedRatings'] = _totalExpectedRatings;
    map['_id'] = _id;
    map['owner'] = _owner;
    map['placeLongitude'] = _placeLongitude;
    map['placeLatitude'] = _placeLatitude;
    map['user'] = _user;
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    map['__v'] = _v;
    return map;
  }
}
