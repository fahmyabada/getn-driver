class StatusHistory {
  StatusHistory({
      String? status, 
      String? date, 
      String? type, 
      String? id, 
      String? user,}){
    _status = status;
    _date = date;
    _type = type;
    _id = id;
    _user = user;
}

  StatusHistory.fromJson(dynamic json) {
    _status = json['status'];
    _date = json['date'];
    _type = json['type'];
    _id = json['_id'];
    _user = json['user'];
  }
  String? _status;
  String? _date;
  String? _type;
  String? _id;
  String? _user;

  String? get status => _status;
  String? get date => _date;
  String? get type => _type;
  String? get id => _id;
  String? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['date'] = _date;
    map['type'] = _type;
    map['_id'] = _id;
    map['user'] = _user;
    return map;
  }

}