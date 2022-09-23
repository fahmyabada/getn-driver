class Title {
  Title({
      String? en, 
      String? ar,}){
    _en = en;
    _ar = ar;
}

  Title.fromJson(dynamic json) {
    _en = json['en'];
    _ar = json['ar'];
  }
  String? _en;
  String? _ar;

  String? get en => _en;
  String? get ar => _ar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = _en;
    map['ar'] = _ar;
    return map;
  }

}