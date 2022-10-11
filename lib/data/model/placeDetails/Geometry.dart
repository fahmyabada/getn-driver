import 'Location.dart';

class Geometry {
  Geometry({
      Location? location,}){
    _location = location;
}

  Geometry.fromJson(dynamic json) {
    _location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }
  Location? _location;

  Location? get location => _location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    return map;
  }

}