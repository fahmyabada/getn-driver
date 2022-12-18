import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/api_result_model.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TripDetailsRepository {
  Future<Either<String, Data?>> getTripDetails(String id);

  Future<Either<String, DataRequest?>> putTrip(
      String id,
      String type,
      String comment,
      double consumptionKM,
      String latitude,
      String longitude,
      String place,
      String branch);

  Future<Either<String, APIResultModel>> setPolyLines(LatLng l1, LatLng l2);

  Future<Either<String, Position>> getCurrentLocation();
}
