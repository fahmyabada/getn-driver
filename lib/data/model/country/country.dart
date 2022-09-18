import 'package:flutter/foundation.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';

class Country {
  final List<CountryData>? data;
  final int? totalCount;
  final int? tableCount;
  final int? page;
  final int? limit;

  Country({
    this.data,
    this.totalCount,
    this.tableCount,
    this.page,
    this.limit,
  });

  Country.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)
            ?.map(
                (dynamic e) => CountryData.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalCount = json['totalCount'] as int?,
        tableCount = json['tableCount'] as int?,
        page = json['page'] as int?,
        limit = json['limit'] as int?;

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'totalCount': totalCount,
        'tableCount': tableCount,
        'page': page,
        'limit': limit
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Country &&
        listEquals(other.data, data) &&
        other.totalCount == totalCount &&
        other.tableCount == tableCount &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return data.hashCode ^
        totalCount.hashCode ^
        tableCount.hashCode ^
        page.hashCode ^
        limit.hashCode;
  }
}



