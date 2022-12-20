import 'package:getn_driver/data/model/country/Title.dart';

class DataRole {
  DataRole({
    String? id,
    Title? title,
    String? type,
  }) {
    _id = id;
    _title = title;
    _type = type;
  }

  DataRole.fromJson(dynamic json) {
    _id = json['_id'];
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _type = json['type'];
  }

  String? _id;
  Title? _title;
  String? _type;

  String? get id => _id;

  Title? get title => _title;

  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    map['type'] = _type;
    return map;
  }
}
