import 'Result.dart';

class PlaceDetails {
  PlaceDetails({
      Result? result,}){
    _result = result;
}

  PlaceDetails.fromJson(dynamic json) {
    _result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  Result? _result;

  Result? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_result != null) {
      map['result'] = _result?.toJson();
    }
    return map;
  }

}