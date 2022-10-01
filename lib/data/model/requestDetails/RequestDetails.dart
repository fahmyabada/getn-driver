import 'package:getn_driver/data/model/request/Days.dart';
import 'package:getn_driver/data/model/request/From.dart';
import 'package:getn_driver/data/model/request/StatusHistory.dart';

import 'Client.dart';

class RequestDetails {
  RequestDetails({
      From? from, 
      String? createdAt, 
      String? updatedAt, 
      String? status, 
      String? to, 
      int? subtotalPoints, 
      int? subtotalPrice, 
      int? consumptionPoints, 
      int? consumptionKM, 
      int? packagesPoints, 
      int? totalPackagesPrice, 
      int? consumptionPackagesPoints, 
      int? consumptionPackagesKM, 
      int? totalPoints, 
      int? refund, 
      int? totalPrice, 
      int? totalConsumptionPoints, 
      int? totalConsumptionKM, 
      String? paymentMethod, 
      int? referenceId, 
      String? paymentStatus, 
      String? packagesPaymentStatus, 
      String? id, 
      String? driver, 
      String? car, 
      String? carCategory, 
      Client? client, 
      List<Days>? days, 
      List<StatusHistory>? statusHistory, 
      int? v,}){
    _from = from;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _status = status;
    _to = to;
    _subtotalPoints = subtotalPoints;
    _subtotalPrice = subtotalPrice;
    _consumptionPoints = consumptionPoints;
    _consumptionKM = consumptionKM;
    _packagesPoints = packagesPoints;
    _totalPackagesPrice = totalPackagesPrice;
    _consumptionPackagesPoints = consumptionPackagesPoints;
    _consumptionPackagesKM = consumptionPackagesKM;
    _totalPoints = totalPoints;
    _refund = refund;
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
    _v = v;
}

  RequestDetails.fromJson(dynamic json) {
    _from = json['from'] != null ? From.fromJson(json['from']) : null;
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _status = json['status'];
    _to = json['to'];
    _subtotalPoints = json['subtotalPoints'];
    _subtotalPrice = json['subtotalPrice'];
    _consumptionPoints = json['consumptionPoints'];
    _consumptionKM = json['consumptionKM'];
    _packagesPoints = json['packagesPoints'];
    _totalPackagesPrice = json['totalPackagesPrice'];
    _consumptionPackagesPoints = json['consumptionPackagesPoints'];
    _consumptionPackagesKM = json['consumptionPackagesKM'];
    _totalPoints = json['totalPoints'];
    _refund = json['refund'];
    _totalPrice = json['totalPrice'];
    _totalConsumptionPoints = json['totalConsumptionPoints'];
    _totalConsumptionKM = json['totalConsumptionKM'];
    _paymentMethod = json['paymentMethod'];
    _referenceId = json['referenceId'];
    _paymentStatus = json['paymentStatus'];
    _packagesPaymentStatus = json['packagesPaymentStatus'];
    _id = json['_id'];
    _driver = json['driver'];
    _car = json['car'];
    _carCategory = json['carCategory'];
    _client = json['client'] != null ? Client.fromJson(json['client']) : null;
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
    _v = json['__v'];
  }
  From? _from;
  String? _createdAt;
  String? _updatedAt;
  String? _status;
  String? _to;
  int? _subtotalPoints;
  int? _subtotalPrice;
  int? _consumptionPoints;
  int? _consumptionKM;
  int? _packagesPoints;
  int? _totalPackagesPrice;
  int? _consumptionPackagesPoints;
  int? _consumptionPackagesKM;
  int? _totalPoints;
  int? _refund;
  int? _totalPrice;
  int? _totalConsumptionPoints;
  int? _totalConsumptionKM;
  String? _paymentMethod;
  int? _referenceId;
  String? _paymentStatus;
  String? _packagesPaymentStatus;
  String? _id;
  String? _driver;
  String? _car;
  String? _carCategory;
  Client? _client;
  List<Days>? _days;
  List<StatusHistory>? _statusHistory;
  int? _v;

  From? get from => _from;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get status => _status;
  String? get to => _to;
  int? get subtotalPoints => _subtotalPoints;
  int? get subtotalPrice => _subtotalPrice;
  int? get consumptionPoints => _consumptionPoints;
  int? get consumptionKM => _consumptionKM;
  int? get packagesPoints => _packagesPoints;
  int? get totalPackagesPrice => _totalPackagesPrice;
  int? get consumptionPackagesPoints => _consumptionPackagesPoints;
  int? get consumptionPackagesKM => _consumptionPackagesKM;
  int? get totalPoints => _totalPoints;
  int? get refund => _refund;
  int? get totalPrice => _totalPrice;
  int? get totalConsumptionPoints => _totalConsumptionPoints;
  int? get totalConsumptionKM => _totalConsumptionKM;
  String? get paymentMethod => _paymentMethod;
  int? get referenceId => _referenceId;
  String? get paymentStatus => _paymentStatus;
  String? get packagesPaymentStatus => _packagesPaymentStatus;
  String? get id => _id;
  String? get driver => _driver;
  String? get car => _car;
  String? get carCategory => _carCategory;
  Client? get client => _client;
  List<Days>? get days => _days;
  List<StatusHistory>? get statusHistory => _statusHistory;
  int? get v => _v;

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
    map['subtotalPrice'] = _subtotalPrice;
    map['consumptionPoints'] = _consumptionPoints;
    map['consumptionKM'] = _consumptionKM;
    map['packagesPoints'] = _packagesPoints;
    map['totalPackagesPrice'] = _totalPackagesPrice;
    map['consumptionPackagesPoints'] = _consumptionPackagesPoints;
    map['consumptionPackagesKM'] = _consumptionPackagesKM;
    map['totalPoints'] = _totalPoints;
    map['refund'] = _refund;
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
    if (_client != null) {
      map['client'] = _client?.toJson();
    }
    if (_days != null) {
      map['days'] = _days?.map((v) => v.toJson()).toList();
    }
    if (_statusHistory != null) {
      map['statusHistory'] = _statusHistory?.map((v) => v.toJson()).toList();
    }
    map['__v'] = _v;
    return map;
  }

}