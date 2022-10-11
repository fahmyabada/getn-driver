import 'Geometry.dart';

class Result {
  Result({
      Geometry? geometry,}){
    _geometry = geometry;
}

  Result.fromJson(dynamic json) {
    _geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }
  Geometry? _geometry;

  Geometry? get geometry => _geometry;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_geometry != null) {
      map['geometry'] = _geometry?.toJson();
    }
    return map;
  }

}