class To {
  To({
      String? placeTitle, 
      String? placeLatitude, 
      String? placeLongitude,}){
    _placeTitle = placeTitle;
    _placeLatitude = placeLatitude;
    _placeLongitude = placeLongitude;
}

  To.fromJson(dynamic json) {
    _placeTitle = json['placeTitle'];
    _placeLatitude = json['placeLatitude'];
    _placeLongitude = json['placeLongitude'];
  }
  String? _placeTitle;
  String? _placeLatitude;
  String? _placeLongitude;

  String? get placeTitle => _placeTitle;
  String? get placeLatitude => _placeLatitude;
  String? get placeLongitude => _placeLongitude;


  @override
  String toString() {
    return 'To{_placeTitle: $_placeTitle, _placeLatitude: $_placeLatitude, _placeLongitude: $_placeLongitude}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['placeTitle'] = _placeTitle;
    map['placeLatitude'] = _placeLatitude;
    map['placeLongitude'] = _placeLongitude;
    return map;
  }

}