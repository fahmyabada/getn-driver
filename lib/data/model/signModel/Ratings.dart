class Ratings {
  Ratings({
    int? drive,
    int? car,
    int? guide,
    int? attitude,
    int? driveAverage,
    int? carAverage,
    int? guideAverage,
  }) {
    _drive = drive;
    _car = car;
    _guide = guide;
    _attitude = attitude;
    _driveAverage = driveAverage;
    _carAverage = carAverage;
    _guideAverage = guideAverage;
  }

  Ratings.fromJson(dynamic json) {
    _drive = json['drive'];
    _car = json['car'];
    _guide = json['guide'];
    _attitude = json['attitude'];
    _driveAverage = json['driveAverage'];
    _carAverage = json['carAverage'];
    _guideAverage = json['guideAverage'];
  }

  int? _drive;
  int? _car;
  int? _guide;
  int? _attitude;
  int? _driveAverage;
  int? _carAverage;
  int? _guideAverage;

  int? get drive => _drive;

  int? get car => _car;

  int? get guide => _guide;

  int? get attitude => _attitude;

  int? get driveAverage => _driveAverage;

  int? get carAverage => _carAverage;

  int? get guideAverage => _guideAverage;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['drive'] = _drive;
    map['car'] = _car;
    map['guide'] = _guide;
    map['attitude'] = _attitude;
    map['driveAverage'] = _driveAverage;
    map['carAverage'] = _carAverage;
    map['guideAverage'] = _guideAverage;
    return map;
  }
}
