class WhatsappCountryRequest {
  WhatsappCountryRequest({
      String? id, 
      String? code,}){
    _id = id;
    _code = code;
}

  WhatsappCountryRequest.fromJson(dynamic json) {
    _id = json['_id'];
    _code = json['code'];
  }
  String? _id;
  String? _code;

  String? get id => _id;
  String? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['code'] = _code;
    return map;
  }

}