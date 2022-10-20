import 'package:getn_driver/data/model/country/Image.dart';

import 'Gallery.dart';

class CarRegisterationModel {
  CarRegisterationModel({
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
    String? carModel,
    String? carModelYear,
    String? carColor,
    String? carNumber,
    Image? frontCarLicenseImage,
    Image? backCarLicenseImage,
    List<Gallery>? gallery,
    String? driver,
    int? v,
  }) {
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
    _frontCarLicenseImage = frontCarLicenseImage;
    _backCarLicenseImage = backCarLicenseImage;
    _gallery = gallery;
    _driver = driver;
    _v = v;
  }

  CarRegisterationModel.fromJson(dynamic json) {
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
    _carModel = json['carModel'];
    _carModelYear = json['carModelYear'];
    _carColor = json['carColor'];
    _carNumber = json['carNumber'];
    _frontCarLicenseImage = json['frontCarLicenseImage'] != null
        ? Image.fromJson(json['frontCarLicenseImage'])
        : null;
    _backCarLicenseImage = json['backCarLicenseImage'] != null
        ? Image.fromJson(json['backCarLicenseImage'])
        : null;
    if (json['gallery'] != null) {
      _gallery = [];
      json['gallery'].forEach((v) {
        _gallery?.add(Gallery.fromJson(v));
      });
    }
    _driver = json['driver'];
    _v = json['__v'];
  }

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
  String? _carModel;
  String? _carModelYear;
  String? _carColor;
  String? _carNumber;
  Image? _frontCarLicenseImage;
  Image? _backCarLicenseImage;
  List<Gallery>? _gallery;
  String? _driver;
  int? _v;

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

  String? get carModel => _carModel;

  String? get carModelYear => _carModelYear;

  String? get carColor => _carColor;

  String? get carNumber => _carNumber;

  Image? get frontCarLicenseImage => _frontCarLicenseImage;

  Image? get backCarLicenseImage => _backCarLicenseImage;

  List<Gallery>? get gallery => _gallery;

  String? get driver => _driver;

  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['carModel'] = _carModel;
    map['carModelYear'] = _carModelYear;
    map['carColor'] = _carColor;
    map['carNumber'] = _carNumber;
    if (_frontCarLicenseImage != null) {
      map['frontCarLicenseImage'] = _frontCarLicenseImage?.toJson();
    }
    if (_backCarLicenseImage != null) {
      map['backCarLicenseImage'] = _backCarLicenseImage?.toJson();
    }
    if (_gallery != null) {
      map['gallery'] = _gallery?.map((v) => v.toJson()).toList();
    }
    map['driver'] = _driver;
    map['__v'] = _v;
    return map;
  }
}
