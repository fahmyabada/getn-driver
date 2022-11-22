import 'package:getn_driver/data/model/sendOtp/Message.dart';

import 'Country.dart';
import 'VerifyImage.dart';

class SignModel {
  SignModel({
    String? id,
    VerifyImage? image,
    VerifyImage? frontNationalImage,
    VerifyImage? backNationalImage,
    VerifyImage? verifyImage,
    String? name,
    bool? hasCar,
    String? phone,
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
    _hasCar = hasCar;
    _phone = phone;
    _country = country;
    _token = token;
    _message = message;
  }

  SignModel.fromJson(dynamic json) {
    _id = json['_id'];
    _image = json['image'] != null
        ? VerifyImage.fromJson(json['image'])
        : null;
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
    _phone = json['phone'];
    _hasCar = json['hasCar'];
    _country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    _token = json['token'];
    _message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  String? _id;
  VerifyImage? _image;
  VerifyImage? _frontNationalImage;
  VerifyImage? _backNationalImage;
  VerifyImage? _verifyImage;
  String? _name;
  String? _phone;
  bool? _hasCar;
  Country? _country;
  String? _token;
  Message? _message;

  String? get id => _id;

  VerifyImage? get image => _image;

  VerifyImage? get frontNationalImage => _frontNationalImage;

  VerifyImage? get backNationalImage => _backNationalImage;

  VerifyImage? get verifyImage => _verifyImage;

  String? get name => _name;

  bool? get hasCar => _hasCar;

  String? get phone => _phone;

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
    map['hasCar'] = _hasCar;
    map['name'] = _name;
    map['phone'] = _phone;
    if (_country != null) {
      map['country'] = _country?.toJson();
    }
    map['token'] = _token;
    return map;
  }
}
