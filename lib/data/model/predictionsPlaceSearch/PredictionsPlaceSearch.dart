import 'Predictions.dart';

class PredictionsPlaceSearch {
  PredictionsPlaceSearch({
      List<Predictions>? predictions,}){
    _predictions = predictions;
}

  PredictionsPlaceSearch.fromJson(dynamic json) {
    if (json['predictions'] != null) {
      _predictions = [];
      json['predictions'].forEach((v) {
        _predictions?.add(Predictions.fromJson(v));
      });
    }
  }
  List<Predictions>? _predictions;

  List<Predictions>? get predictions => _predictions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_predictions != null) {
      map['predictions'] = _predictions?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}