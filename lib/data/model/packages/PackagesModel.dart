import 'Data.dart';

class PackagesModel {
  PackagesModel({
      List<Data>? data, 
      int? totalCount, 
      int? tableCount, 
      int? page, 
      int? limit,}){
    _data = data;
    _totalCount = totalCount;
    _tableCount = tableCount;
    _page = page;
    _limit = limit;
}

  PackagesModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _totalCount = json['totalCount'];
    _tableCount = json['tableCount'];
    _page = json['page'];
    _limit = json['limit'];
  }
  List<Data>? _data;
  int? _totalCount;
  int? _tableCount;
  int? _page;
  int? _limit;

  List<Data>? get data => _data;
  int? get totalCount => _totalCount;
  int? get tableCount => _tableCount;
  int? get page => _page;
  int? get limit => _limit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['totalCount'] = _totalCount;
    map['tableCount'] = _tableCount;
    map['page'] = _page;
    map['limit'] = _limit;
    return map;
  }

}