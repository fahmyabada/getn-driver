class Data {
  Data({
      String? user, 
      String? type,
      String? status,
      double? amount,
      String? createdAt, 
      String? updatedAt, 
      String? id, 
      String? driver, 
      String? request, 
      String? comment, 
      int? v,}){
    _user = user;
    _type = type;
    _status = status;
    _amount = amount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _id = id;
    _driver = driver;
    _request = request;
    _comment = comment;
    _v = v;
}

  Data.fromJson(dynamic json) {
    _user = json['user'];
    _type = json['type'];
    _status = json['status'];
    _amount = json['amount'] is int ? double.parse(json['amount'].toString()) : json['amount'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _id = json['_id'];
    _driver = json['driver'];
    _request = json['request'];
    _comment = json['comment'];
    _v = json['__v'];
  }
  String? _user;
  String? _type;
  String? _status;
  double? _amount;
  String? _createdAt;
  String? _updatedAt;
  String? _id;
  String? _driver;
  String? _request;
  String? _comment;
  int? _v;

  String? get user => _user;
  String? get type => _type;
  String? get status => _status;
  double? get amount => _amount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get id => _id;
  String? get driver => _driver;
  String? get request => _request;
  String? get comment => _comment;
  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = _user;
    map['type'] = _type;
    map['status'] = _status;
    map['amount'] = _amount;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['_id'] = _id;
    map['driver'] = _driver;
    map['request'] = _request;
    map['comment'] = _comment;
    map['__v'] = _v;
    return map;
  }

}