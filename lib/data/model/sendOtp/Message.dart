class Message {
  Message({String? phone, String? verifyCode}) {
    _phone = phone;
    _verifyCode = verifyCode;
  }

  Message.fromJson(dynamic json) {
    _phone = json['phone'];
    _phone = json['verifyCode'];
  }

  String? _phone;
  String? _verifyCode;

  String? get phone => _phone;

  String? get verifyCode => _verifyCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['verifyCode'] = _verifyCode;
    return map;
  }
}
