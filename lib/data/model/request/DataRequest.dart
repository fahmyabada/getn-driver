import 'package:getn_driver/data/model/request/Client.dart';
import 'package:getn_driver/data/model/request/CurrentDayRequest.dart';
import 'package:getn_driver/data/model/trips/To.dart';

import 'CarCategoryRequest.dart';
import 'Days.dart';
import 'From.dart';

class DataRequest {
  DataRequest(
      {From? from,
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
      double? packagesPoints,
      String? paymentMethod,
      int? referenceId,
      int? hoursToTakeAction,
      String? paymentStatus,
      String? packagesPaymentStatus,
      String? id,
      String? driver,
      String? car,
      String? client,
      CarCategoryRequest? carCategory,
      List<Days>? days,
      CurrentDayRequest? currentDayRequest}) {
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
    _hoursToTakeAction = hoursToTakeAction;
    _paymentStatus = paymentStatus;
    _packagesPaymentStatus = packagesPaymentStatus;
    _packagesPoints = packagesPoints;
    _id = id;
    _driver = driver;
    _car = car;
    _client = client;
    _days = days;
    _carCategory = carCategory;
    _currentDayRequest = currentDayRequest;
  }

  DataRequest.fromJson(dynamic json) {
    _from = json['from'] != null ? From.fromJson(json['from']) : null;
    json['to'] is String
        ? _to = json['to']
        : _to2 = json['to'] != null ? To.fromJson(json['to']) : null;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _subtotalPoints = json['subtotalPoints'] != null
        ? double.parse(json['subtotalPoints'].toString())
        : 0.0;
    _consumptionPoints = double.parse(json['consumptionPoints'].toString());
    _consumptionKM = json['consumptionKM'] != null
        ? double.parse(json['consumptionKM'].toString())
        : 0.0;
    _consumptionPackagesPoints = json['consumptionPackagesPoints'] != null
        ? double.parse(json['consumptionPackagesPoints'].toString())
        : 0.0;
    print('object***********${json['packagesPoints']}');
    _packagesPoints = json['packagesPoints'] != null
        ? double.parse(json['packagesPoints'].toString())
        : 0.0;
    _totalPrice = json['totalPrice'] != null
        ? double.parse(json['totalPrice'].toString())
        : 0.0;
    _totalConsumptionPoints = json['totalConsumptionPoints'] != null
        ? double.parse(json['totalConsumptionPoints'].toString())
        : 0.0;

    _totalConsumptionKM = json['totalConsumptionKM'] != null
        ? double.parse(json['totalConsumptionKM'].toString())
        : 0.0;
    _paymentMethod = json['paymentMethod'];
    _referenceId = json['referenceId'];
    _hoursToTakeAction = json['hoursToTakeAction'];
    _paymentStatus = json['paymentStatus'];
    _packagesPaymentStatus = json['packagesPaymentStatus'];
    _id = json['_id'];
    _driver = json['driver'];
    _car = json['car'];
    json['client'] is String
        ? _client = json['client']
        : _client2 =
            json['client'] != null ? Client.fromJson(json['client']) : null;
    _currentDayRequest = json['currentDay'] != null
        ? CurrentDayRequest.fromJson(json['currentDay'])
        : null;
    _carCategory = json['carCategory'] != null
        ? CarCategoryRequest.fromJson(json['carCategory'])
        : null;
    if (json['days'] != null) {
      _days = [];
      json['days'].forEach((v) {
        _days?.add(Days.fromJson(v));
      });
    }
  }

  From? _from;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  String? _to;
  To? _to2;
  double? _subtotalPoints;
  double? _consumptionPoints;
  double? _consumptionKM;
  double? _consumptionPackagesPoints;
  double? _totalPrice;
  double? _packagesPoints;
  double? _totalConsumptionPoints;
  double? _totalConsumptionKM;
  int? _hoursToTakeAction;
  String? _paymentMethod;
  int? _referenceId;
  String? _paymentStatus;
  String? _packagesPaymentStatus;
  String? _id;
  String? _driver;
  String? _car;
  String? _client;
  Client? _client2;
  CarCategoryRequest? _carCategory;
  List<Days>? _days;
  CurrentDayRequest? _currentDayRequest;

  From? get from => _from;

  To? get to2 => _to2;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get status => _status;

  String? get to => _to;

  double? get subtotalPoints => _subtotalPoints;

  double? get packagesPoints => _packagesPoints;

  double? get consumptionPoints => _consumptionPoints;

  double? get consumptionKM => _consumptionKM;

  double? get consumptionPackagesPoints => _consumptionPackagesPoints;

  double? get totalPrice => _totalPrice;

  double? get totalConsumptionPoints => _totalConsumptionPoints;

  double? get totalConsumptionKM => _totalConsumptionKM;

  String? get paymentMethod => _paymentMethod;

  int? get referenceId => _referenceId;

  int? get hoursToTakeAction => _hoursToTakeAction;

  String? get paymentStatus => _paymentStatus;

  String? get packagesPaymentStatus => _packagesPaymentStatus;

  String? get id => _id;

  String? get driver => _driver;

  String? get car => _car;

  String? get client => _client;

  CarCategoryRequest? get carCategory => _carCategory;

  CurrentDayRequest? get currentDay => _currentDayRequest;

  Client? get client2 => _client2;

  List<Days>? get days => _days;

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
    map['subtotalPoints'] = _subtotalPoints;
    map['consumptionPoints'] = _consumptionPoints;
    map['consumptionKM'] = _consumptionKM;
    map['consumptionPackagesPoints'] = _consumptionPackagesPoints;
    map['totalPrice'] = _totalPrice;
    map['totalConsumptionPoints'] = _totalConsumptionPoints;
    map['totalConsumptionKM'] = _totalConsumptionKM;
    map['paymentMethod'] = _paymentMethod;
    map['referenceId'] = _referenceId;
    map['hoursToTakeAction'] = _hoursToTakeAction;
    map['paymentStatus'] = _paymentStatus;
    map['packagesPaymentStatus'] = _packagesPaymentStatus;
    map['packagesPoints'] = _packagesPoints;
    map['_id'] = _id;
    map['driver'] = _driver;
    map['car'] = _car;
    map['client'] = _client;
    if (_carCategory != null) {
      map['carCategory'] = _carCategory?.toJson();
    }
    if (_days != null) {
      map['days'] = _days?.map((v) => v.toJson()).toList();
    }
    if (_currentDayRequest != null) {
      map['currentDay'] = _currentDayRequest?.toJson();
    }
    return map;
  }
}
