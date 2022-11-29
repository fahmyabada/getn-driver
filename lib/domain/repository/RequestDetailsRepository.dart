import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';

abstract class RequestDetailsRepository {
  Future<Either<String, DataRequest?>> getRequestDetails(String id);

  Future<Either<String, Trips?>> getTripsRequestDetails(
      Map<String, dynamic> body);

  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment);

  Future<Either<String, Position>> getCurrentLocation();

  Future<Either<String, Request>> getLastTrip(String idRequest);
}
