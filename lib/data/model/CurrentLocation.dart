class CurrentLocation {
  CurrentLocation({
    String? description,
    double? longitude,
    double? latitude,
  }) {
    _description = description;
    _longitude = longitude;
    _latitude = latitude;
  }

  CurrentLocation.fromJson(dynamic json) {
    _description = json['description'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
  }

  String? _description;
  double? _longitude;
  double? _latitude;

  String? get description => _description;

  double? get longitude => _longitude;

  double? get latitude => _latitude;


  @override
  String toString() {
    return 'CurrentLocation{_description: $_description, _longitude: $_longitude, _latitude: $_latitude}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    return map;
  }
}
