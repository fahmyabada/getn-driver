import 'package:getn_driver/data/model/country/Image.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/signModel/Ratings.dart';

import '../sendOtp/Message.dart';
import 'Area.dart';
import 'City.dart';

class EditProfileModel {
  EditProfileModel({
    Image? image,
    Image? frontNationalImage,
    Image? backNationalImage,
    Image? frontDriveImage,
    Image? backDriveImage,
    Ratings? ratings,
    int? wallet,
    int? holdWallet,
    bool? status,
    bool? acceptTermsAndConditions,
    bool? acceptPermissions,
    String? createdAt,
    String? updatedAt,
    String? birthDate,
    String? whatsApp,
    bool? individual,
    bool? available,
    bool? verified,
    int? ratingsCount,
    int? totalRatings,
    int? totalExpectedRatings,
    int? ratingsAverage,
    int? totalTrips,
    int? totalRequests,
    List<String>? availabilities,
    String? id,
    String? fcmToken,
    String? name,
    String? role,
    String? email,
    String? phone,
    Country? country,
    City? city,
    Area? area,
    String? address,
    String? brief,
    String? nationalId,
    Message? message,
    int? v,
  }) {
    _image = image;
    _frontNationalImage = frontNationalImage;
    _backNationalImage = backNationalImage;
    _frontDriveImage = frontDriveImage;
    _backDriveImage = backDriveImage;
    _ratings = ratings;
    _status = status;
    _acceptTermsAndConditions = acceptTermsAndConditions;
    _acceptPermissions = acceptPermissions;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _birthDate = birthDate;
    _individual = individual;
    _available = available;
    _verified = verified;
    _ratingsCount = ratingsCount;
    _totalRatings = totalRatings;
    _totalExpectedRatings = totalExpectedRatings;
    _ratingsAverage = ratingsAverage;
    _totalTrips = totalTrips;
    _totalRequests = totalRequests;
    _availabilities = availabilities;
    _id = id;
    _fcmToken = fcmToken;
    _name = name;
    _role = role;
    _email = email;
    _phone = phone;
    _country = country;
    _city = city;
    _area = area;
    _address = address;
    _whatsApp = whatsApp;
    _brief = brief;
    _nationalId = nationalId;
    _v = v;
    _message = message;
  }

  EditProfileModel.fromJson(dynamic json) {
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
    _frontNationalImage = json['frontNationalImage'] != null
        ? Image.fromJson(json['frontNationalImage'])
        : null;
    _backNationalImage = json['backNationalImage'] != null
        ? Image.fromJson(json['backNationalImage'])
        : null;
    _frontDriveImage = json['frontDriveImage'] != null
        ? Image.fromJson(json['frontDriveImage'])
        : null;
    _backDriveImage = json['backDriveImage'] != null
        ? Image.fromJson(json['backDriveImage'])
        : null;
    _ratings =
        json['ratings'] != null ? Ratings.fromJson(json['ratings']) : null;
    _status = json['status'];
    _acceptTermsAndConditions = json['acceptTermsAndConditions'];
    _acceptPermissions = json['acceptPermissions'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _birthDate = json['birthDate'];
    _individual = json['individual'];
    _available = json['available'];
    _verified = json['verified'];
    _ratingsCount = json['ratingsCount'];
    _totalRatings = json['totalRatings'];
    _totalExpectedRatings = json['totalExpectedRatings'];
    _ratingsAverage = json['ratingsAverage'];
    _totalTrips = json['totalTrips'];
    _totalRequests = json['totalRequests'];
    _availabilities = json['availabilities'] != null
        ? json['availabilities'].cast<String>()
        : [];
    _id = json['_id'];
    _fcmToken = json['fcmToken'];
    _name = json['name'];
    _role = json['role'];
    _email = json['email'];
    _phone = json['phone'];
    _country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    _city = json['city'] != null ? City.fromJson(json['city']) : null;
    _area = json['area'] != null ? Area.fromJson(json['area']) : null;
    _address = json['address'];
    _brief = json['brief'];
    _nationalId = json['nationalId'];
    _v = json['__v'];
    _whatsApp = json['whatsapp'];
    _message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Image? _image;
  Image? _frontNationalImage;
  Image? _backNationalImage;
  Image? _frontDriveImage;
  Image? _backDriveImage;
  Ratings? _ratings;
  bool? _status;
  bool? _acceptTermsAndConditions;
  bool? _acceptPermissions;
  String? _whatsApp;
  String? _createdAt;
  String? _updatedAt;
  String? _birthDate;
  bool? _individual;
  bool? _available;
  bool? _verified;
  int? _ratingsCount;
  int? _totalRatings;
  int? _totalExpectedRatings;
  int? _ratingsAverage;
  int? _totalTrips;
  int? _totalRequests;
  List<String>? _availabilities;
  String? _id;
  String? _fcmToken;
  String? _name;
  String? _role;
  String? _email;
  String? _phone;
  Country? _country;
  City? _city;
  Area? _area;
  String? _address;
  String? _brief;
  String? _nationalId;
  int? _v;
  Message? _message;

  Image? get image => _image;

  Image? get frontNationalImage => _frontNationalImage;

  Image? get backNationalImage => _backNationalImage;

  Image? get frontDriveImage => _frontDriveImage;

  Image? get backDriveImage => _backDriveImage;

  Ratings? get ratings => _ratings;

  bool? get status => _status;

  bool? get acceptTermsAndConditions => _acceptTermsAndConditions;

  bool? get acceptPermissions => _acceptPermissions;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get birthDate => _birthDate;

  bool? get individual => _individual;

  bool? get available => _available;

  bool? get verified => _verified;

  int? get ratingsCount => _ratingsCount;

  int? get totalRatings => _totalRatings;

  int? get totalExpectedRatings => _totalExpectedRatings;

  int? get ratingsAverage => _ratingsAverage;

  int? get totalTrips => _totalTrips;

  int? get totalRequests => _totalRequests;

  List<String>? get availabilities => _availabilities;

  String? get id => _id;

  String? get fcmToken => _fcmToken;

  String? get name => _name;

  String? get role => _role;

  String? get email => _email;

  String? get phone => _phone;

  Country? get country => _country;

  City? get city => _city;

  Area? get area => _area;

  String? get address => _address;

  String? get brief => _brief;

  String? get nationalId => _nationalId;

  int? get v => _v;

  String? get whatsApp => _whatsApp;

  Message? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    if (_frontNationalImage != null) {
      map['frontNationalImage'] = _frontNationalImage?.toJson();
    }
    if (_backNationalImage != null) {
      map['backNationalImage'] = _backNationalImage?.toJson();
    }
    if (_frontDriveImage != null) {
      map['frontDriveImage'] = _frontDriveImage?.toJson();
    }
    if (_backDriveImage != null) {
      map['backDriveImage'] = _backDriveImage?.toJson();
    }
    if (_ratings != null) {
      map['ratings'] = _ratings?.toJson();
    }
    map['status'] = _status;
    map['acceptTermsAndConditions'] = _acceptTermsAndConditions;
    map['acceptPermissions'] = _acceptPermissions;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['birthDate'] = _birthDate;
    map['individual'] = _individual;
    map['available'] = _available;
    map['verified'] = _verified;
    map['ratingsCount'] = _ratingsCount;
    map['totalRatings'] = _totalRatings;
    map['totalExpectedRatings'] = _totalExpectedRatings;
    map['ratingsAverage'] = _ratingsAverage;
    map['totalTrips'] = _totalTrips;
    map['totalRequests'] = _totalRequests;
    map['availabilities'] = _availabilities;
    map['_id'] = _id;
    map['fcmToken'] = _fcmToken;
    map['name'] = _name;
    map['role'] = _role;
    map['email'] = _email;
    map['phone'] = _phone;
    if (_country != null) {
      map['country'] = _country?.toJson();
    }
    if (_city != null) {
      map['city'] = _city?.toJson();
    }
    if (_area != null) {
      map['area'] = _area?.toJson();
    }
    map['address'] = _address;
    map['brief'] = _brief;
    map['nationalId'] = _nationalId;
    map['__v'] = _v;
    return map;
  }
}
