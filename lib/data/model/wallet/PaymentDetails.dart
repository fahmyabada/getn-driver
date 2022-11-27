class PaymentDetails {
  PaymentDetails({
    String? accountType,
    String? accountName,
    String? bankName,
    String? accountNumber,
    String? iban,
  }) {
    _accountType = accountType;
    _accountName = accountName;
    _bankName = bankName;
    _accountNumber = accountNumber;
    _iban = iban;
  }

  PaymentDetails.fromJson(dynamic json) {
    _accountType = json['accountType'];
    _accountName = json['accountName'];
    _bankName = json['bankName'];
    _accountNumber = json['accountNumber'].toString();
    _iban = json['iban'].toString();
  }

  String? _accountType;
  String? _accountName;
  String? _bankName;
  String? _accountNumber;
  String? _iban;

  String? get accountType => _accountType;

  String? get accountName => _accountName;

  String? get bankName => _bankName;

  String? get accountNumber => _accountNumber;

  String? get iban => _iban;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accountType'] = _accountType;
    map['accountName'] = _accountName;
    map['bankName'] = _bankName;
    map['accountNumber'] = _accountNumber;
    map['iban'] = _iban;
    return map;
  }
}
