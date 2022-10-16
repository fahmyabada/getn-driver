class CurrentLocation {
  CurrentLocation({
    String? description,
    String? branchId,
    String? placeId,
    double? longitude,
    double? latitude,
    bool? firstTime,
  }) {
    _placeId = placeId;
    _branchId = branchId;
    _description = description;
    _longitude = longitude;
    _latitude = latitude;
    _firstTime = firstTime;
  }

  CurrentLocation.fromJson(dynamic json) {
    _placeId = json['placeId'];
    _branchId = json['branchId'];
    _description = json['description'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
  }

  String? _description;
  String? _placeId;
  String? _branchId;
  double? _longitude;
  double? _latitude;
  bool? _firstTime;

  String? get description => _description;

  String? get placeId => _placeId;

  String? get branchId => _branchId;

  double? get longitude => _longitude;

  double? get latitude => _latitude;

  bool? get firstTime => _firstTime;

  @override
  String toString() {
    return 'CurrentLocation{_description: $_description, _placeId: $_placeId, _branchId: $_branchId, _longitude: $_longitude, _latitude: $_latitude, _firstTime: $_firstTime}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    map['placeId'] = _placeId;
    map['branchId'] = _branchId;
    return map;
  }
}
