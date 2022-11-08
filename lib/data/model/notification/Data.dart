import 'Content.dart';
import 'Title.dart';

class Data {
  Data({
    Content? content,
    Title? title,
    String? createdAt,
    String? updatedAt,
    String? app,
    String? type,
    List<String>? drivers,
    List<String>? driversSeen,
    String? id,
    String? url,
    String? typeId,
    String? parentId,
    int? v,
  }) {
    _content = content;
    _title = title;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _app = app;
    _type = type;
    _drivers = drivers;
    _driversSeen = driversSeen;
    _id = id;
    _url = url;
    _typeId = typeId;
    _parentId = parentId;
    _v = v;
  }

  Data.fromJson(dynamic json) {
    _content =
        json['content'] != null ? Content.fromJson(json['content']) : null;
    _title = json['title'] != null ? Title.fromJson(json['title']) : null;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _app = json['app'];
    _type = json['type'];
    _drivers = json['drivers'] != null ? json['drivers'].cast<String>() : [];
    _driversSeen =
        json['driversSeen'] != null ? json['driversSeen'].cast<String>() : [];
    _id = json['_id'];
    _url = json['url'];
    _typeId = json['typeId'];
    _parentId = json['parentId'];
    _v = json['__v'];
  }

  Content? _content;
  Title? _title;
  String? _createdAt;
  String? _updatedAt;
  String? _app;
  String? _type;
  List<String>? _drivers;
  List<String>? _driversSeen;
  String? _id;
  String? _url;
  String? _typeId;
  String? _parentId;
  int? _v;

  Content? get content => _content;

  Title? get title => _title;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get app => _app;

  String? get type => _type;

  List<String>? get drivers => _drivers;

  List<String>? get driversSeen => _driversSeen;

  String? get id => _id;

  String? get url => _url;

  String? get typeId => _typeId;

  String? get parentId => _parentId;

  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_content != null) {
      map['content'] = _content?.toJson();
    }
    if (_title != null) {
      map['title'] = _title?.toJson();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['app'] = _app;
    map['type'] = _type;
    map['drivers'] = _drivers;
    map['driversSeen'] = _driversSeen;
    map['_id'] = _id;
    map['url'] = _url;
    map['typeId'] = _typeId;
    map['__v'] = _v;
    return map;
  }
}
