class Predictions {
  Predictions({
      String? description, 
      String? placeId,}){
    _description = description;
    _placeId = placeId;
}

  Predictions.fromJson(dynamic json) {
    _description = json['description'];
    _placeId = json['place_id'];
  }
  String? _description;
  String? _placeId;

  String? get description => _description;
  String? get placeId => _placeId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['place_id'] = _placeId;
    return map;
  }

}