import 'package:getn_driver/data/model/request/Client.dart';
import 'package:getn_driver/data/model/request/From.dart';
import 'package:getn_driver/data/model/request/StatusHistory.dart';

import 'To.dart';

class Data {
  Data({
    From? from,
    To? to,
    String? createdAt,
    String? date,
    String? startDate,
    String? updatedAt,
    String? status,
    double? consumptionPoints,
    int? oneKMPoints,
    int? referenceId,
    String? id,
    String? request,
    double? consumptionKM,
    String? driver,
    String? client,
    List<StatusHistory>? statusHistory,
    int? v,
  }) {
    _from = from;
    _to = to;
    _createdAt = createdAt;
    _date = date;
    _startDate = startDate;
    _updatedAt = updatedAt;
    _status = status;
    _consumptionPoints = consumptionPoints;
    _oneKMPoints = oneKMPoints;
    _referenceId = referenceId;
    _id = id;
    _request = request;
    _consumptionKM = consumptionKM;
    _driver = driver;
    _client = client;
    _statusHistory = statusHistory;
    _v = v;
  }

  Data.fromJson(dynamic json) {
    _from = json['from'] != null ? From.fromJson(json['from']) : null;
    _to = json['to'] != null ? To.fromJson(json['to']) : null;
    _createdAt = json['createdAt'];
    _date = json['date'];
    _startDate = json['startDate'];
    _endDate = json['endDate'] ?? "";
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _consumptionPoints = double.parse(json['consumptionPoints'].toString());
    _oneKMPoints = json['oneKMPoints'];
    _referenceId = json['referenceId'];
    _id = json['_id'];
    _request = json['request'];
    _consumptionKM = double.parse(json['consumptionKM'].toString());
    _driver = json['driver'];
    json['client'] is String
        ? _client = json['client']
        : _client2 =
            json['client'] != null ? Client.fromJson(json['client']) : null;
    if (json['statusHistory'] != null) {
      _statusHistory = [];
      json['statusHistory'].forEach((v) {
        _statusHistory?.add(StatusHistory.fromJson(v));
      });
    }
    _v = json['__v'];
  }

  From? _from;
  To? _to;
  String? _createdAt;
  String? _date;
  String? _startDate;
  String? _endDate;
  String? _updatedAt;
  String? _status;
  double? _consumptionPoints;
  int? _oneKMPoints;
  int? _referenceId;
  String? _id;
  String? _request;
  double? _consumptionKM;
  String? _driver;
  String? _client;
  Client? _client2;
  List<StatusHistory>? _statusHistory;
  int? _v;

  From? get from => _from;

  To? get to => _to;

  String? get createdAt => _createdAt;

  String? get date => _date;

  String? get startDate => _startDate;

  String? get endDate => _endDate;

  String? get updatedAt => _updatedAt;

  String? get status => _status;

  double? get consumptionPoints => _consumptionPoints;

  int? get oneKMPoints => _oneKMPoints;

  int? get referenceId => _referenceId;

  String? get id => _id;

  String? get request => _request;

  double? get consumptionKM => _consumptionKM;

  String? get driver => _driver;

  String? get client => _client;

  Client? get client2 => _client2;

  List<StatusHistory>? get statusHistory => _statusHistory;

  int? get v => _v;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_from != null) {
      map['from'] = _from?.toJson();
    }
    if (_to != null) {
      map['to'] = _to?.toJson();
    }
    map['createdAt'] = _createdAt;
    map['date'] = _date;
    map['startDate'] = _startDate;
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    map['consumptionPoints'] = _consumptionPoints;
    map['oneKMPoints'] = _oneKMPoints;
    map['referenceId'] = _referenceId;
    map['_id'] = _id;
    map['request'] = _request;
    map['consumptionKM'] = _consumptionKM;
    map['driver'] = _driver;
    map['client'] = _client;
    if (_statusHistory != null) {
      map['statusHistory'] = _statusHistory?.map((v) => v.toJson()).toList();
    }
    map['__v'] = _v;
    return map;
  }
}
