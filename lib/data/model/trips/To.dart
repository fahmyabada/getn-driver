class To {
  To({
    String? placeTitle,
    String? placeLatitude,
    String? placeLongitude,
    String? place,
    String? branch,
  }) {
    _placeTitle = placeTitle;
    _placeLatitude = placeLatitude;
    _placeLongitude = placeLongitude;
    _place = place;
    _branch = branch;
  }

  To.fromJson(dynamic json) {
    _placeTitle = json['placeTitle'];
    _placeLatitude = json['placeLatitude'];
    _placeLongitude = json['placeLongitude'];
    _place = json['place'];
    _branch = json['branch'];
  }

  String? _placeTitle;
  String? _placeLatitude;
  String? _placeLongitude;
  String? _place;
  String? _branch;

  String? get placeTitle => _placeTitle;

  String? get placeLatitude => _placeLatitude;

  String? get placeLongitude => _placeLongitude;

  String? get place => _place;

  String? get branch => _branch;

  @override
  String toString() {
    return 'To{_placeTitle: $_placeTitle, _placeLatitude: $_placeLatitude, _placeLongitude: $_placeLongitude, _place: $_place, _branch: $_branch}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['placeTitle'] = _placeTitle;
    map['placeLatitude'] = _placeLatitude;
    map['placeLongitude'] = _placeLongitude;
    map['place'] = _place;
    map['branch'] = _branch;
    return map;
  }
}
