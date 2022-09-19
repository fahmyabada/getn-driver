class Message {
  Message({
      String? phone,}){
    _phone = phone;
}

  Message.fromJson(dynamic json) {
    _phone = json['phone'];
  }
  String? _phone;

  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    return map;
  }

}