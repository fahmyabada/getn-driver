class Icon {
  Icon({
      String? src, 
      String? mimetype,}){
    _src = src;
    _mimetype = mimetype;
}

  Icon.fromJson(dynamic json) {
    _src = json['src'];
    _mimetype = json['mimetype'];
  }
  String? _src;
  String? _mimetype;

  String? get src => _src;
  String? get mimetype => _mimetype;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['src'] = _src;
    map['mimetype'] = _mimetype;
    return map;
  }

}