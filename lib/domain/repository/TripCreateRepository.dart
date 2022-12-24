import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/data/model/CanCreateTrip/CanCreateTrip.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/trips/Data.dart';

abstract class TripCreateRepository {
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(String text);

  Future<Either<String, PlaceDetails?>> placeDetails(String placeId);

  Future<Either<String, Data?>> createTrip(CreateTripModel data);

  Future<Either<String, CanCreateTrip?>> canCreateTrip(CreateTripModel data);
}
