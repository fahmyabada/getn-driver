import 'Data.dart';

class WalletModel {
  WalletModel({
    List<Data>? data,
    int? totalCount,
    int? tableCount,
    double? wallet,
    double? holdWallet,
    int? page,
    int? limit,
  }) {
    _data = data;
    _totalCount = totalCount;
    _tableCount = tableCount;
    _wallet = wallet;
    _holdWallet = holdWallet;
    _page = page;
    _limit = limit;
  }

  WalletModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _totalCount = json['totalCount'];
    _tableCount = json['tableCount'];
    _wallet = json['wallet'] is int
        ? double.parse(json['wallet'].toString())
        : json['wallet'];
    _holdWallet = json['holdWallet'] is int
        ? double.parse(json['holdWallet'].toString())
        : json['holdWallet'];
    _page = json['page'];
    _limit = json['limit'];
  }

  List<Data>? _data;
  int? _totalCount;
  int? _tableCount;
  double? _wallet;
  double? _holdWallet;
  int? _page;
  int? _limit;

  List<Data>? get data => _data;

  int? get totalCount => _totalCount;

  int? get tableCount => _tableCount;

  double? get wallet => _wallet;

  double? get holdWallet => _holdWallet;

  int? get page => _page;

  int? get limit => _limit;

  @override
  String toString() {
    return 'WalletModel{_data: $_data, _totalCount: $_totalCount, _tableCount: $_tableCount, _wallet: $_wallet, _holdWallet: $_holdWallet, _page: $_page, _limit: $_limit}';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['totalCount'] = _totalCount;
    map['tableCount'] = _tableCount;
    map['wallet'] = _wallet;
    map['holdWallet'] = _holdWallet;
    map['page'] = _page;
    map['limit'] = _limit;
    return map;
  }
}
