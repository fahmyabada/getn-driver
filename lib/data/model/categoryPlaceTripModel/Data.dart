
import '../carCategory/Icon.dart';
import 'Title.dart';


class Data {
  Data({
      Title? title,
      Icon? icon,
      String? id,
      }){
    _title = title;
    _icon = icon;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _icon = json['icon'] != null ? Icon.fromJson(json['icon']) : null;
    _id = json['_id'];
  }
  Title? _title;
  Icon? _icon;
  String? _id;

  Title? get title => _title;
  Icon? get icon => _icon;
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    if (_icon != null) {
      map['icon'] = _icon?.toJson();
    }
    map['_id'] = _id;
    return map;
  }

}