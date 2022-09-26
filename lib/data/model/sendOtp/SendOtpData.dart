import 'Message.dart';

class SendOtpData {
  SendOtpData({
    bool? otpSend,
    bool? isAlreadyUser,
    String? code,
    Message? message,
  }) {
    _otpSend = otpSend;
    _isAlreadyUser = isAlreadyUser;
    _code = code;
    _message = message;
  }

  SendOtpData.fromJson(dynamic json) {
    _otpSend = json['otpSend'];
    _isAlreadyUser = json['isAlreadyUser'];
    _code = json['code'];
    _message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  bool? _otpSend;
  bool? _isAlreadyUser;
  String? _code;
  Message? _message;

  bool? get otpSend => _otpSend;

  bool? get isAlreadyUser => _isAlreadyUser;

  String? get code => _code;

  Message? get message => _message;


  @override
  String toString() {
    return 'SendOtpData{_otpSend: $_otpSend, _isAlreadyUser: $_isAlreadyUser, _code: $_code, _message: $_message}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otpSend'] = _otpSend;
    map['isAlreadyUser'] = _isAlreadyUser;
    map['code'] = _code;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    return map;
  }
}
