import 'package:getn_driver/data/model/carModel/BackCarLicenseImage.dart';
import 'package:getn_driver/data/model/carModel/FrontCarLicenseImage.dart';
import 'package:getn_driver/data/model/carModel/Gallery.dart';
import 'package:getn_driver/data/model/myCar/Image.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;

import 'Driver.dart';
import 'CarCategory.dart';
import 'User.dart';

class Data {
  Data({
      FrontCarLicenseImage? frontCarLicenseImage, 
      BackCarLicenseImage? backCarLicenseImage, 
      Image? image,
      bool? available, 
      bool? individual, 
      int? tripCount, 
      int? rating, 
      int? ratingsCount, 
      int? totalRatingsCount, 
      int? seq, 
      int? numberOfSeats, 
      bool? status, 
      String? updatedAt, 
      String? createdAt, 
      String? id,
      category.Data? carModel,
      String? carModelYear,
      category.Data? carColor,
      String? carNumber, 
      List<Gallery>? gallery, 
      Driver? driver, 
      int? v, 
      CarCategory? carCategory, 
      String? carType, 
      User? user,}){
    _frontCarLicenseImage = frontCarLicenseImage;
    _backCarLicenseImage = backCarLicenseImage;
    _image = image;
    _available = available;
    _individual = individual;
    _tripCount = tripCount;
    _rating = rating;
    _ratingsCount = ratingsCount;
    _totalRatingsCount = totalRatingsCount;
    _seq = seq;
    _numberOfSeats = numberOfSeats;
    _status = status;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _carModel = carModel;
    _carModelYear = carModelYear;
    _carColor = carColor;
    _carNumber = carNumber;
    _gallery = gallery;
    _driver = driver;
    _v = v;
    _carCategory = carCategory;
    _carType = carType;
    _user = user;
}

  Data.fromJson(dynamic json) {
    _frontCarLicenseImage = json['frontCarLicenseImage'] != null ? FrontCarLicenseImage.fromJson(json['frontCarLicenseImage']) : null;
    _backCarLicenseImage = json['backCarLicenseImage'] != null ? BackCarLicenseImage.fromJson(json['backCarLicenseImage']) : null;
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
    _available = json['available'];
    _individual = json['individual'];
    _tripCount = json['tripCount'];
    _rating = json['rating'];
    _ratingsCount = json['ratingsCount'];
    _totalRatingsCount = json['totalRatingsCount'];
    _seq = json['seq'];
    _numberOfSeats = json['numberOfSeats'];
    _status = json['status'];
    _updatedAt = json['updatedAt'];
    _createdAt = json['createdAt'];
    _id = json['_id'];
    _carModel = json['carModel'] != null ? category.Data.fromJson(json['carModel']) : null;
    _carModelYear = json['carModelYear'];
    _carColor = json['carColor'] != null ? category.Data.fromJson(json['carColor']) : null;
    _carNumber = json['carNumber'];
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
    _driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    _v = json['__v'];
    _carCategory = json['carCategory'] != null ? CarCategory.fromJson(json['carCategory']) : null;
    _carType = json['carType'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  FrontCarLicenseImage? _frontCarLicenseImage;
  BackCarLicenseImage? _backCarLicenseImage;
  Image? _image;
  bool? _available;
  bool? _individual;
  int? _tripCount;
  int? _rating;
  int? _ratingsCount;
  int? _totalRatingsCount;
  int? _seq;
  int? _numberOfSeats;
  bool? _status;
  String? _updatedAt;
  String? _createdAt;
  String? _id;
  category.Data? _carModel;
  String? _carModelYear;
  category.Data? _carColor;
  String? _carNumber;
  List<Gallery>? _gallery;
  Driver? _driver;
  int? _v;
  CarCategory? _carCategory;
  String? _carType;
  User? _user;

  FrontCarLicenseImage? get frontCarLicenseImage => _frontCarLicenseImage;
  BackCarLicenseImage? get backCarLicenseImage => _backCarLicenseImage;
  Image? get image => _image;
  bool? get available => _available;
  bool? get individual => _individual;
  int? get tripCount => _tripCount;
  int? get rating => _rating;
  int? get ratingsCount => _ratingsCount;
  int? get totalRatingsCount => _totalRatingsCount;
  int? get seq => _seq;
  int? get numberOfSeats => _numberOfSeats;
  bool? get status => _status;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  String? get id => _id;
  category.Data? get carModel => _carModel;
  String? get carModelYear => _carModelYear;
  category.Data? get carColor => _carColor;
  String? get carNumber => _carNumber;
  List<Gallery>? get gallery => _gallery;
  Driver? get driver => _driver;
  int? get v => _v;
  CarCategory? get carCategory => _carCategory;
  String? get carType => _carType;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_frontCarLicenseImage != null) {
      map['frontCarLicenseImage'] = _frontCarLicenseImage?.toJson();
    }
    if (_backCarLicenseImage != null) {
      map['backCarLicenseImage'] = _backCarLicenseImage?.toJson();
    }
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    map['available'] = _available;
    map['individual'] = _individual;
    map['tripCount'] = _tripCount;
    map['rating'] = _rating;
    map['ratingsCount'] = _ratingsCount;
    map['totalRatingsCount'] = _totalRatingsCount;
    map['seq'] = _seq;
    map['numberOfSeats'] = _numberOfSeats;
    map['status'] = _status;
    map['updatedAt'] = _updatedAt;
    map['createdAt'] = _createdAt;
    map['_id'] = _id;
    if (_carModel != null) {
      map['carModel'] = _carModel?.toJson();
    }
    map['carModelYear'] = _carModelYear;
    if (_carColor != null) {
      map['carColor'] = _carColor?.toJson();
    }
    map['carNumber'] = _carNumber;
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    if (_driver != null) {
      map['driver'] = _driver?.toJson();
    }
    map['__v'] = _v;
    if (_carCategory != null) {
      map['carCategory'] = _carCategory?.toJson();
    }
    map['carType'] = _carType;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }

}