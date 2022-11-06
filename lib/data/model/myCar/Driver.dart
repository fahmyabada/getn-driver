import 'Image.dart';
import 'VerifyImage.dart';
import 'FrontNationalImage.dart';
import 'BackNationalImage.dart';
import 'FrontDriveImage.dart';
import 'BackDriveImage.dart';
import 'Ratings.dart';

class Driver {
  Driver({
      Image? image, 
      VerifyImage? verifyImage, 
      FrontNationalImage? frontNationalImage, 
      BackNationalImage? backNationalImage, 
      FrontDriveImage? frontDriveImage, 
      BackDriveImage? backDriveImage, 
      Ratings? ratings, 
      double? wallet, 
      double? holdWallet, 
      bool? status, 
      bool? acceptTermsAndConditions, 
      bool? acceptPermissions, 
      String? createdAt, 
      String? updatedAt, 
      String? birthDate, 
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
      String? phone, 
      String? name, 
      String? email, 
      String? whatsapp, 
      String? country, 
      String? city, 
      String? area, 
      String? address, 
      String? role, 
      String? fcmToken, 
      int? v, 
      String? brief, 
      String? nationalId,}){
    _image = image;
    _verifyImage = verifyImage;
    _frontNationalImage = frontNationalImage;
    _backNationalImage = backNationalImage;
    _frontDriveImage = frontDriveImage;
    _backDriveImage = backDriveImage;
    _ratings = ratings;
    _wallet = wallet;
    _holdWallet = holdWallet;
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
    _phone = phone;
    _name = name;
    _email = email;
    _whatsapp = whatsapp;
    _country = country;
    _city = city;
    _area = area;
    _address = address;
    _role = role;
    _fcmToken = fcmToken;
    _v = v;
    _brief = brief;
    _nationalId = nationalId;
}

  Driver.fromJson(dynamic json) {
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
    _verifyImage = json['verifyImage'] != null ? VerifyImage.fromJson(json['verifyImage']) : null;
    _frontNationalImage = json['frontNationalImage'] != null ? FrontNationalImage.fromJson(json['frontNationalImage']) : null;
    _backNationalImage = json['backNationalImage'] != null ? BackNationalImage.fromJson(json['backNationalImage']) : null;
    _frontDriveImage = json['frontDriveImage'] != null ? FrontDriveImage.fromJson(json['frontDriveImage']) : null;
    _backDriveImage = json['backDriveImage'] != null ? BackDriveImage.fromJson(json['backDriveImage']) : null;
    _ratings = json['ratings'] != null ? Ratings.fromJson(json['ratings']) : null;
    _wallet = json['wallet'];
    _holdWallet = json['holdWallet'];
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
    _availabilities = json['availabilities'] != null ? json['availabilities'].cast<String>() : [];
    _id = json['_id'];
    _phone = json['phone'];
    _name = json['name'];
    _email = json['email'];
    _whatsapp = json['whatsapp'];
    _country = json['country'];
    _city = json['city'];
    _area = json['area'];
    _address = json['address'];
    _role = json['role'];
    _fcmToken = json['fcmToken'];
    _v = json['__v'];
    _brief = json['brief'];
    _nationalId = json['nationalId'];
  }
  Image? _image;
  VerifyImage? _verifyImage;
  FrontNationalImage? _frontNationalImage;
  BackNationalImage? _backNationalImage;
  FrontDriveImage? _frontDriveImage;
  BackDriveImage? _backDriveImage;
  Ratings? _ratings;
  double? _wallet;
  double? _holdWallet;
  bool? _status;
  bool? _acceptTermsAndConditions;
  bool? _acceptPermissions;
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
  String? _phone;
  String? _name;
  String? _email;
  String? _whatsapp;
  String? _country;
  String? _city;
  String? _area;
  String? _address;
  String? _role;
  String? _fcmToken;
  int? _v;
  String? _brief;
  String? _nationalId;

  Image? get image => _image;
  VerifyImage? get verifyImage => _verifyImage;
  FrontNationalImage? get frontNationalImage => _frontNationalImage;
  BackNationalImage? get backNationalImage => _backNationalImage;
  FrontDriveImage? get frontDriveImage => _frontDriveImage;
  BackDriveImage? get backDriveImage => _backDriveImage;
  Ratings? get ratings => _ratings;
  double? get wallet => _wallet;
  double? get holdWallet => _holdWallet;
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
  String? get phone => _phone;
  String? get name => _name;
  String? get email => _email;
  String? get whatsapp => _whatsapp;
  String? get country => _country;
  String? get city => _city;
  String? get area => _area;
  String? get address => _address;
  String? get role => _role;
  String? get fcmToken => _fcmToken;
  int? get v => _v;
  String? get brief => _brief;
  String? get nationalId => _nationalId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    if (_verifyImage != null) {
      map['verifyImage'] = _verifyImage?.toJson();
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
    map['wallet'] = _wallet;
    map['holdWallet'] = _holdWallet;
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
    map['phone'] = _phone;
    map['name'] = _name;
    map['email'] = _email;
    map['whatsapp'] = _whatsapp;
    map['country'] = _country;
    map['city'] = _city;
    map['area'] = _area;
    map['address'] = _address;
    map['role'] = _role;
    map['fcmToken'] = _fcmToken;
    map['__v'] = _v;
    map['brief'] = _brief;
    map['nationalId'] = _nationalId;
    return map;
  }

}