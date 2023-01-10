class DeleteAccountModel {
  DeleteAccountModel({
      String? type, 
      String? createdAt, 
      String? updatedAt, 
      String? id, 
      String? message, 
      String? client, 
      String? phone, 
      String? country, 
      String? name, 
      String? email,}){
    _type = type;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _message = message;
    _client = client;
    _phone = phone;
    _country = country;
    _name = name;
    _email = email;
}

  DeleteAccountModel.fromJson(dynamic json) {
    _type = json['type'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _message = json['message'];
    _client = json['client'];
    _phone = json['phone'];
    _country = json['country'];
    _name = json['name'];
    _email = json['email'];
  }
  String? _type;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  String? _message;
  String? _client;
  String? _phone;
  String? _country;
  String? _name;
  String? _email;

  String? get type => _type;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get id => _id;
  String? get message => _message;
  String? get client => _client;
  String? get phone => _phone;
  String? get country => _country;
  String? get name => _name;
  String? get email => _email;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['message'] = _message;
    map['client'] = _client;
    map['phone'] = _phone;
    map['country'] = _country;
    map['name'] = _name;
    map['email'] = _email;
    return map;
  }

}