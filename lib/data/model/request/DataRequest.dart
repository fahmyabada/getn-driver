import 'package:getn_driver/data/model/request/Client.dart';
import 'package:getn_driver/data/model/trips/To.dart';

import 'Days.dart';
import 'From.dart';
import 'StatusHistory.dart';

class DataRequest {
  DataRequest({
    From? from,
    String? createdAt,
    String? updatedAt,
    String? status,
    String? to,
    double? consumptionPoints,
    double? consumptionKM,
    double? consumptionPackagesPoints,
    double? totalPrice,
    double? totalConsumptionPoints,
    double? totalConsumptionKM,
    String? paymentMethod,
    int? referenceId,
    String? paymentStatus,
    String? packagesPaymentStatus,
    String? id,
    String? driver,
    String? car,
    String? carCategory,
    String? client,
    List<Days>? days,
    List<StatusHistory>? statusHistory,
  }) {
    _from = from;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _to = to;
    _consumptionPoints = consumptionPoints;
    _consumptionKM = consumptionKM;
    _consumptionPackagesPoints = consumptionPackagesPoints;
    _totalPrice = totalPrice;
    _totalConsumptionPoints = totalConsumptionPoints;
    _totalConsumptionKM = totalConsumptionKM;
    _paymentMethod = paymentMethod;
    _referenceId = referenceId;
    _paymentStatus = paymentStatus;
    _packagesPaymentStatus = packagesPaymentStatus;
    _id = id;
    _driver = driver;
    _car = car;
    _carCategory = carCategory;
    _client = client;
    _days = days;
    _statusHistory = statusHistory;
  }

  DataRequest.fromJson(dynamic json) {
    _from = json['from'] != null ? From.fromJson(json['from']) : null;
    json['to'] is String
        ? _to = json['to']
        : _to2 = json['to'] != null ? To.fromJson(json['to']) : null;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _consumptionPoints = double.parse(json['consumptionPoints'].toString());
    _consumptionKM = json['consumptionKM'] is int ? 0.0 : json['consumptionKM'];
    _consumptionPackagesPoints = json['consumptionPackagesPoints'] is int
        ? 0.0
        : json['consumptionPackagesPoints'];
    _totalPrice = json['totalPrice'] is int ? 0.0 : json['totalPrice'];
    _totalConsumptionPoints = json['totalConsumptionPoints'] is int
        ? 0.0
        : json['totalConsumptionPoints'];
    _totalConsumptionKM =
        json['totalConsumptionKM'] is int ? 0.0 : json['totalConsumptionKM'];
    _paymentMethod = json['paymentMethod'];
    _referenceId = json['referenceId'];
    _paymentStatus = json['paymentStatus'];
    _packagesPaymentStatus = json['packagesPaymentStatus'];
    _id = json['_id'];
    _driver = json['driver'];
    _car = json['car'];
    _carCategory = json['carCategory'];
    json['client'] is String
        ? _client = json['client']
        : _client2 =
            json['client'] != null ? Client.fromJson(json['client']) : null;
    if (json['days'] != null) {
      _days = [];
      json['days'].forEach((v) {
        _days?.add(Days.fromJson(v));
      });
    }
    if (json['statusHistory'] != null) {
      _statusHistory = [];
      json['statusHistory'].forEach((v) {
        _statusHistory?.add(StatusHistory.fromJson(v));
      });
    }
  }

  From? _from;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  String? _to;
  To? _to2;
  double? _consumptionPoints;
  double? _consumptionKM;
  double? _consumptionPackagesPoints;
  double? _totalPrice;
  double? _totalConsumptionPoints;
  double? _totalConsumptionKM;
  String? _paymentMethod;
  int? _referenceId;
  String? _paymentStatus;
  String? _packagesPaymentStatus;
  String? _id;
  String? _driver;
  String? _car;
  String? _carCategory;
  String? _client;
  Client? _client2;
  List<Days>? _days;
  List<StatusHistory>? _statusHistory;

  From? get from => _from;

  To? get to2 => _to2;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get status => _status;

  String? get to => _to;

  double? get consumptionPoints => _consumptionPoints;

  double? get consumptionKM => _consumptionKM;

  double? get consumptionPackagesPoints => _consumptionPackagesPoints;

  double? get totalPrice => _totalPrice;

  double? get totalConsumptionPoints => _totalConsumptionPoints;

  double? get totalConsumptionKM => _totalConsumptionKM;

  String? get paymentMethod => _paymentMethod;

  int? get referenceId => _referenceId;

  String? get paymentStatus => _paymentStatus;

  String? get packagesPaymentStatus => _packagesPaymentStatus;

  String? get id => _id;

  String? get driver => _driver;

  String? get car => _car;

  String? get carCategory => _carCategory;

  String? get client => _client;

  Client? get client2 => _client2;

  List<Days>? get days => _days;

  List<StatusHistory>? get statusHistory => _statusHistory;


  @override
  String toString() {
    return 'DataRequest{_from: $_from, _to2: $_to2, _referenceId: $_referenceId}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_from != null) {
      map['from'] = _from?.toJson();
    }
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['status'] = _status;
    map['to'] = _to;
    map['consumptionPoints'] = _consumptionPoints;
    map['consumptionKM'] = _consumptionKM;
    map['consumptionPackagesPoints'] = _consumptionPackagesPoints;
    map['totalPrice'] = _totalPrice;
    map['totalConsumptionPoints'] = _totalConsumptionPoints;
    map['totalConsumptionKM'] = _totalConsumptionKM;
    map['paymentMethod'] = _paymentMethod;
    map['referenceId'] = _referenceId;
    map['paymentStatus'] = _paymentStatus;
    map['packagesPaymentStatus'] = _packagesPaymentStatus;
    map['_id'] = _id;
    map['driver'] = _driver;
    map['car'] = _car;
    map['carCategory'] = _carCategory;
    map['client'] = _client;
    if (_days != null) {
      map['days'] = _days?.map((v) => v.toJson()).toList();
    }
    if (_statusHistory != null) {
      map['statusHistory'] = _statusHistory?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
