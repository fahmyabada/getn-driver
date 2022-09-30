class From {
  From({
      String? date, 
      String? placeTitle, 
      String? placeLatitude, 
      String? placeLongitude,}){
    _date = date;
    _placeTitle = placeTitle;
    _placeLatitude = placeLatitude;
    _placeLongitude = placeLongitude;
}

  From.fromJson(dynamic json) {
    _date = json['date'];
    _placeTitle = json['placeTitle'];
    _placeLatitude = json['placeLatitude'];
    _placeLongitude = json['placeLongitude'];
  }
  String? _date;
  String? _placeTitle;
  String? _placeLatitude;
  String? _placeLongitude;

  String? get date => _date;
  String? get placeTitle => _placeTitle;
  String? get placeLatitude => _placeLatitude;
  String? get placeLongitude => _placeLongitude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    map['placeTitle'] = _placeTitle;
    map['placeLatitude'] = _placeLatitude;
    map['placeLongitude'] = _placeLongitude;
    return map;
  }

}