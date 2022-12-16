class CarCategoryRequest {
  CarCategoryRequest({
    double? oneKMPoints,
    String? id,
    double? points,}){
    _oneKMPoints = oneKMPoints;
    _id = id;
    _points = points;
  }

  CarCategoryRequest.fromJson(dynamic json) {
    _oneKMPoints = double.parse(json['oneKMPoints'].toString());
    _id = json['_id'];
    _points = double.parse(json['points'].toString());
  }
  double? _oneKMPoints;
  String? _id;
  double? _points;

  double? get oneKMPoints => _oneKMPoints;
  String? get id => _id;
  double? get points => _points;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['oneKMPoints'] = _oneKMPoints;
    map['_id'] = _id;
    map['points'] = _points;
    return map;
  }

}