class Data {
  Data({
    String? user,
    String? type,
    String? status,
    double? amount,
    String? createdAt,
    String? id,
    String? driver,
    String? request,
    String? comment,
  }) {
    _user = user;
    _type = type;
    _status = status;
    _amount = amount;
    _createdAt = createdAt;
    _id = id;
    _driver = driver;
    _request = request;
    _comment = comment;
  }

  Data.fromJson(dynamic json) {
    _user = json['user'];
    _type = json['type'];
    _status = json['status'];
    _amount = json['amount'] is int
        ? double.parse(json['amount'].toString())
        : json['amount'];
    _createdAt = json['createdAt'];
    _id = json['_id'];
    _driver = json['driver'];
    _request = json['request'];
    _comment = json['comment'];
  }

  String? _user;
  String? _type;
  String? _status;
  double? _amount;
  String? _createdAt;
  String? _id;
  String? _driver;
  String? _request;
  String? _comment;

  String? get user => _user;

  String? get type => _type;

  double? get amount => _amount;

  String? get createdAt => _createdAt;

  String? get status => _status;

  String? get id => _id;

  String? get driver => _driver;

  String? get request => _request;

  String? get comment => _comment;


  @override
  String toString() {
    return 'Data{_user: $_user, _type: $_type, _status: $_status, _amount: $_amount, _createdAt: $_createdAt, _id: $_id, _driver: $_driver, _request: $_request, _comment: $_comment}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user'] = _user;
    map['type'] = _type;
    map['status'] = _status;
    map['amount'] = _amount;
    map['createdAt'] = _createdAt;
    map['_id'] = _id;
    map['driver'] = _driver;
    map['request'] = _request;
    map['comment'] = _comment;
    return map;
  }
}
