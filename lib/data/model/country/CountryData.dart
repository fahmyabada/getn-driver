import 'package:getn_driver/data/model/country/IconModel.dart';

class CountryData {
  final Map<String, dynamic>? title;
  final IconModel? icon;
  final String? id;
  final String? code;
  CountryData({
    this.title,
    this.icon,
    this.id,
    this.code,
  });

  CountryData.fromJson(Map<String, dynamic> json)
      : title = (json['title'] as Map<String, dynamic>?) != null
      ? json['title'] as Map<String, dynamic>
      : null,
        icon = (json['icon'] as Map<String, dynamic>?) != null
            ? IconModel.fromJson(json['icon'] as Map<String, dynamic>)
            : null,
        id = json['_id'] as String?,
        code = json['code'] as String?;

  Map<String, dynamic> toJson() => {
    'title': title,
    'icon': icon?.toJson(),
    'id': id,
    'code': code,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryData &&
        other.title == title &&
        other.icon == icon &&
        other.id == id &&
        other.code == code;
  }

  @override
  int get hashCode {
    return title.hashCode ^ icon.hashCode ^ id.hashCode ^ code.hashCode;
  }
}
