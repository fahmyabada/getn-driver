import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/requestDetails/RequestDetails.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';

abstract class RequestDetailsRepository {
  Future<Either<String, RequestDetails?>> getRequestDetails(String id);
  Future<Either<String, Trips?>> getTripsRequestDetails(Map<String, dynamic> body);
}
