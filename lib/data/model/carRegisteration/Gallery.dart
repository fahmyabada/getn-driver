class Gallery {
  Gallery({
      String? id,
      String? src,
      String? mimetype,}){
    _id = id;
    _src = src;
    _mimetype = mimetype;
}

  Gallery.fromJson(dynamic json) {
    _id = json['_id'];
    _src = json['src'];
    _mimetype = json['mimetype'];
  }
  String? _id;
  String? _src;
  String? _mimetype;

  String? get id => _id;
  String? get src => _src;
  String? get mimetype => _mimetype;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['src'] = _src;
    map['mimetype'] = _mimetype;
    return map;
  }

}