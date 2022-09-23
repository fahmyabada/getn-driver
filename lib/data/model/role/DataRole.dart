class DataRole {
  DataRole({
      String? id, 
      String? title, 
      String? type,}){
    _id = id;
    _title = title;
    _type = type;
}

  DataRole.fromJson(dynamic json) {
    _id = json['_id'];
    _title = json['title'];
    _type = json['type'];
  }
  String? _id;
  String? _title;
  String? _type;

  String? get id => _id;
  String? get title => _title;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['title'] = _title;
    map['type'] = _type;
    return map;
  }

}