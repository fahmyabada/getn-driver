class StatusHistory {
  StatusHistory({
    String? status,
    String? date,
    String? type,
    String? id,
    String? user,
    String? client,
    String? comment,
  }) {
    _status = status;
    _date = date;
    _type = type;
    _id = id;
    _user = user;
    _client = client;
    _comment = comment;
  }

  StatusHistory.fromJson(dynamic json) {
    _status = json['status'];
    _date = json['date'];
    _type = json['type'];
    _id = json['_id'];
    _user = json['user'];
    _client = json['client'];
    _comment = json['comment'];
  }

  String? _status;
  String? _date;
  String? _type;
  String? _id;
  String? _user;
  String? _client;
  String? _comment;

  String? get status => _status;

  String? get date => _date;

  String? get type => _type;

  String? get id => _id;

  String? get user => _user;

  String? get client => _client;

  String? get comment => _comment;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['date'] = _date;
    map['type'] = _type;
    map['_id'] = _id;
    map['user'] = _user;
    map['client'] = _client;
    map['comment'] = _comment;
    return map;
  }
}
