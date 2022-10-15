class Brief {
  Brief({
      dynamic en, 
      dynamic ar,}){
    _en = en;
    _ar = ar;
}

  Brief.fromJson(dynamic json) {
    _en = json['en'];
    _ar = json['ar'];
  }
  dynamic _en;
  dynamic _ar;

  dynamic get en => _en;
  dynamic get ar => _ar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = _en;
    map['ar'] = _ar;
    return map;
  }

}