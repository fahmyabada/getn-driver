class CurrentLocation {
  CurrentLocation({
    String? description,
    double? longitude,
    double? latitude,
    bool? firstTime,
  }) {
    _description = description;
    _longitude = longitude;
    _latitude = latitude;
    _firstTime = firstTime;
  }

  CurrentLocation.fromJson(dynamic json) {
    _description = json['description'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
  }

  String? _description;
  double? _longitude;
  double? _latitude;
  bool? _firstTime;

  String? get description => _description;

  double? get longitude => _longitude;

  double? get latitude => _latitude;

  bool? get firstTime => _firstTime;


  @override
  String toString() {
    return 'CurrentLocation{_description: $_description, _longitude: $_longitude, _latitude: $_latitude, _firstTime: $_firstTime}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    return map;
  }
}
