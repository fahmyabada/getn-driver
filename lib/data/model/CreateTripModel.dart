import 'package:getn_driver/data/model/request/From.dart';
import 'package:getn_driver/data/model/trips/To.dart';

class CreateTripModel {
  CreateTripModel({
    From? from,
    To? to,
    String? startDate,
    String? placeId,
    String? branchId,
    String? request,
    double? consumptionKM,
  }) {
    _from = from;
    _to = to;
    _placeId = placeId;
    _branchId = branchId;
    _startDate = startDate;
    _request = request;
    _consumptionKM = consumptionKM;
  }

  CreateTripModel.fromJson(dynamic json) {
    _from = json['from'] != null ? From.fromJson(json['from']) : null;
    _to = json['to'] != null ? To.fromJson(json['to']) : null;
    _branchId = json['branchId'];
    _placeId = json['placeId'];
    _startDate = json['startDate'];
    _request = json['request'];
    _consumptionKM = double.parse(json['consumptionKM'].toString());
  }

  From? _from;
  To? _to;
  String? _branchId;
  String? _placeId;
  String? _startDate;
  String? _request;
  double? _consumptionKM;

  From? get from => _from;

  To? get to => _to;

  String? get branchId => _branchId;

  String? get placeId => _placeId;

  String? get startDate => _startDate;

  String? get request => _request;

  double? get consumptionKM => _consumptionKM;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_from != null) {
      map['from'] = _from?.toJson();
    }
    if (_to != null) {
      map['to'] = _to?.toJson();
    }
    map['branchId'] = _branchId;
    map['placeId'] = _placeId;
    map['startDate'] = _startDate;
    map['request'] = _request;
    map['consumptionKM'] = _consumptionKM;
    return map;
  }
}
