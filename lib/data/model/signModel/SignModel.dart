import 'package:getn_driver/data/model/sendOtp/Message.dart';

import 'Country.dart';
import 'Ratings.dart';
import 'VerifyImage.dart';

class SignModel {
  SignModel({
    String? id,
    dynamic image,
    VerifyImage? frontNationalImage,
    VerifyImage? backNationalImage,
    VerifyImage? verifyImage,
    String? name,
    Ratings? ratings,
    int? ratingsCount,
    String? phone,
    String? birthDate,
    Country? country,
    Message? message,
    String? token,
  }) {
    _id = id;
    _image = image;
    _frontNationalImage = frontNationalImage;
    _backNationalImage = backNationalImage;
    _verifyImage = verifyImage;
    _name = name;
    _ratings = ratings;
    _ratingsCount = ratingsCount;
    _phone = phone;
    _birthDate = birthDate;
    _country = country;
    _token = token;
    _message = message;
  }

  SignModel.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'];
    _frontNationalImage = json['frontNationalImage'] != null
        ? VerifyImage.fromJson(json['frontNationalImage'])
        : null;
    _backNationalImage = json['backNationalImage'] != null
        ? VerifyImage.fromJson(json['backNationalImage'])
        : null;
    _verifyImage = json['verifyImage'] != "" && json['verifyImage'] != null
        ? VerifyImage.fromJson(json['verifyImage'])
        : null;
    _name = json['name'];
    _ratings =
        json['ratings'] != null ? Ratings.fromJson(json['ratings']) : null;
    _ratingsCount = json['ratingsCount'];
    _phone = json['phone'];
    _birthDate = json['birthDate'];
    _country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    _token = json['token'];
    _message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  String? _id;
  dynamic _image;
  VerifyImage? _frontNationalImage;
  VerifyImage? _backNationalImage;
  VerifyImage? _verifyImage;
  String? _name;
  Ratings? _ratings;
  int? _ratingsCount;
  String? _phone;
  String? _birthDate;
  Country? _country;
  String? _token;
  Message? _message;

  String? get id => _id;

  dynamic get image => _image;

  VerifyImage? get frontNationalImage => _frontNationalImage;

  VerifyImage? get backNationalImage => _backNationalImage;

  VerifyImage? get verifyImage => _verifyImage;

  String? get name => _name;

  Ratings? get ratings => _ratings;

  int? get ratingsCount => _ratingsCount;

  String? get phone => _phone;

  String? get birthDate => _birthDate;

  Country? get country => _country;

  String? get token => _token;

  Message? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['image'] = _image;
    if (_frontNationalImage != null) {
      map['frontNationalImage'] = _frontNationalImage?.toJson();
    }
    if (_backNationalImage != null) {
      map['backNationalImage'] = _backNationalImage?.toJson();
    }
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    if (_verifyImage != null) {
      map['verifyImage'] = _verifyImage?.toJson();
    }
    map['name'] = _name;
    if (_ratings != null) {
      map['ratings'] = _ratings?.toJson();
    }
    map['ratingsCount'] = _ratingsCount;
    map['phone'] = _phone;
    map['birthDate'] = _birthDate;
    if (_country != null) {
      map['country'] = _country?.toJson();
    }
    map['token'] = _token;
    return map;
  }
}
