import 'Message.dart';

class SendOtpData {
  SendOtpData({
      bool? otpSend, 
      bool? isAlreadyUser, 
      Message? message,}){
    _otpSend = otpSend;
    _isAlreadyUser = isAlreadyUser;
    _message = message;
}

  SendOtpData.fromJson(dynamic json) {
    _otpSend = json['otpSend'];
    _isAlreadyUser = json['isAlreadyUser'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }
  bool? _otpSend;
  bool? _isAlreadyUser;
  Message? _message;

  bool? get otpSend => _otpSend;
  bool? get isAlreadyUser => _isAlreadyUser;
  Message? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['otpSend'] = _otpSend;
    map['isAlreadyUser'] = _isAlreadyUser;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    return map;
  }

}