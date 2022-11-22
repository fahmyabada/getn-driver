import 'package:getn_driver/data/model/country/Image.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';

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
  }) {
    _image = image;
    _frontNationalImage = frontNationalImage;
    _backNationalImage = backNationalImage;
    _frontDriveImage = frontDriveImage;
    _backDriveImage = backDriveImage;
    _status = status;
    _acceptTermsAndConditions = acceptTermsAndConditions;
    _acceptPermissions = acceptPermissions;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _birthDate = birthDate;
    _individual = individual;
    _available = available;
    _verified = verified;
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
    _status = json['status'];
    _acceptTermsAndConditions = json['acceptTermsAndConditions'];
    _acceptPermissions = json['acceptPermissions'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _birthDate = json['birthDate'];
    _individual = json['individual'];
    _available = json['available'];
    _verified = json['verified'];
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
    _whatsApp = json['whatsapp'];
    _message =
    json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Image? _image;
  Image? _frontNationalImage;
  Image? _backNationalImage;
  Image? _frontDriveImage;
  Image? _backDriveImage;
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
  Message? _message;

  Image? get image => _image;

  Image? get frontNationalImage => _frontNationalImage;

  Image? get backNationalImage => _backNationalImage;

  Image? get frontDriveImage => _frontDriveImage;

  Image? get backDriveImage => _backDriveImage;


  bool? get status => _status;

  bool? get acceptTermsAndConditions => _acceptTermsAndConditions;

  bool? get acceptPermissions => _acceptPermissions;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get birthDate => _birthDate;

  bool? get individual => _individual;

  bool? get available => _available;

  bool? get verified => _verified;

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
    map['status'] = _status;
    map['acceptTermsAndConditions'] = _acceptTermsAndConditions;
    map['acceptPermissions'] = _acceptPermissions;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['birthDate'] = _birthDate;
    map['individual'] = _individual;
    map['available'] = _available;
    map['verified'] = _verified;
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
    return map;
  }
}
