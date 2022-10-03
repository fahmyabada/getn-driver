import 'Image.dart';

class User {
  User({
    Image? image,
    bool? status,
    String? createdAt,
    String? updatedAt,
    bool? social,
    String? birthDate,
    String? id,
    String? email,
    String? password,
    String? role,
    String? name,
    int? v,
    List<String>? wishlist,
  }) {
    _image = image;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _social = social;
    _birthDate = birthDate;
    _id = id;
    _email = email;
    _password = password;
    _role = role;
    _name = name;
    _v = v;
    _wishlist = wishlist;
  }

  User.fromJson(dynamic json) {
    _image = json['image'] != null
        ? Image.fromJson(json['image'])
        : Image(mimetype: "", src: "");
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _social = json['social'];
    _birthDate = json['birthDate'];
    _id = json['_id'];
    _email = json['email'];
    _password = json['password'];
    _role = json['role'];
    _name = json['name'];
    _v = json['__v'];
    _wishlist = json['wishlist'] != null ? json['wishlist'].cast<String>() : [];
  }

  Image? _image;
  bool? _status;
  String? _createdAt;
  String? _updatedAt;
  bool? _social;
  String? _birthDate;
  String? _id;
  String? _email;
  String? _password;
  String? _role;
  String? _name;
  int? _v;
  List<String>? _wishlist;

  Image? get image => _image;

  bool? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  bool? get social => _social;

  String? get birthDate => _birthDate;

  String? get id => _id;

  String? get email => _email;

  String? get password => _password;

  String? get role => _role;

  String? get name => _name;

  int? get v => _v;

  List<String>? get wishlist => _wishlist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    map['status'] = _status;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['social'] = _social;
    map['birthDate'] = _birthDate;
    map['_id'] = _id;
    map['email'] = _email;
    map['password'] = _password;
    map['role'] = _role;
    map['name'] = _name;
    map['__v'] = _v;
    map['wishlist'] = _wishlist;
    return map;
  }
}
