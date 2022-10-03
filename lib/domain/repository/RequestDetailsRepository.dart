import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';

abstract class RequestDetailsRepository {
  Future<Either<String, DataRequest?>> getRequestDetails(String id);
  Future<Either<String, Trips?>> getTripsRequestDetails(Map<String, dynamic> body);
}
