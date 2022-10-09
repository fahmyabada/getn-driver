import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';

abstract class TripDetailsRepository {
  Future<Either<String, Data?>> getTripDetails(String id);

  Future<Either<String, DataRequest?>> putTrip(String id, String type);
}
