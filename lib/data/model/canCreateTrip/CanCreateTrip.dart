class CanCreateTrip {
  CanCreateTrip({
    bool? canCreateTrip,
    double? packagesPointsLeft,
    double? dayPointsLeft,
    double? leftPoints,
    double? neededPoints,
    double? activatedTrips,
  }) {
    _canCreateTrip = canCreateTrip;
    _packagesPointsLeft = packagesPointsLeft;
    _dayPointsLeft = dayPointsLeft;
    _leftPoints = leftPoints;
    _neededPoints = neededPoints;
    _activatedTrips = activatedTrips;
  }

  CanCreateTrip.fromJson(dynamic json) {
    _canCreateTrip = json['canCreateTrip'];
    _packagesPointsLeft = double.parse(json['packagesPointsLeft'].toString());
    _dayPointsLeft = double.parse(json['dayPointsLeft'].toString());
    _leftPoints = double.parse(json['leftPoints'].toString());
    _neededPoints = double.parse(json['neededPoints'].toString());
    _activatedTrips = double.parse(json['activatedTrips'].toString());
  }

  bool? _canCreateTrip;
  double? _packagesPointsLeft;
  double? _dayPointsLeft;
  double? _leftPoints;
  double? _neededPoints;
  double? _activatedTrips;

  bool? get canCreateTrip => _canCreateTrip;

  double? get packagesPointsLeft => _packagesPointsLeft;

  double? get dayPointsLeft => _dayPointsLeft;

  double? get leftPoints => _leftPoints;

  double? get neededPoints => _neededPoints;

  double? get activatedTrips => _activatedTrips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['canCreateTrip'] = _canCreateTrip;
    map['packagesPointsLeft'] = _packagesPointsLeft;
    map['dayPointsLeft'] = _dayPointsLeft;
    map['leftPoints'] = _leftPoints;
    map['neededPoints'] = _neededPoints;
    map['activatedTrips'] = _activatedTrips;
    return map;
  }
}
