import 'package:getn_driver/data/model/country/Image.dart';
import 'package:getn_driver/data/model/request/WhatsappCountryRequest.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';

import '../request/Area.dart';
import '../request/City.dart';

class Client {
  Client({
    Image? image,
    String? id,
    Country? country,
    String? name,
    Area? area,
    String? phone,
    String? whatsApp,
    City? city,
    WhatsappCountryRequest? whatsappCountryRequest,
  }) {
    _image = image;
    _id = id;
    _country = country;
    _name = name;
    _area = area;
    _city = city;
    _phone = phone;
    _whatsApp = whatsApp;
    _whatsappCountry = whatsappCountryRequest;
  }

  Client.fromJson(dynamic json) {
    _image = json['image'] != null
        ? json['image'] is String
            ? Image(mimetype: "", src: "")
            : Image.fromJson(json['image'])
        : Image(mimetype: "", src: "");
    _id = json['_id'];
    _phone = json['phone'];
    _whatsApp = json['whatsapp'];
    _country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    _name = json['name'];
    _area = json['area'] != null ? Area.fromJson(json['area']) : null;
    _city = json['city'] != null ? City.fromJson(json['city']) : null;
    _whatsappCountry = json['whatsappCountry'] != null
        ? WhatsappCountryRequest.fromJson(json['whatsappCountry'])
        : null;
  }

  Image? _image;
  String? _id;
  Country? _country;
  String? _name;
  Area? _area;
  City? _city;
  String? _phone;
  String? _whatsApp;
  WhatsappCountryRequest? _whatsappCountry;

  Image? get image => _image;

  String? get id => _id;

  Country? get country => _country;

  String? get name => _name;

  Area? get area => _area;

  City? get city => _city;

  String? get phone => _phone;

  String? get whatsApp => _whatsApp;

  WhatsappCountryRequest? get whatsappCountry => _whatsappCountry;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
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
    if (_whatsappCountry != null) {
      map['whatsappCountry'] = _whatsappCountry?.toJson();
    }
    return map;
  }
}
