import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';

class PutTripDetailsUseCase {
  final TripDetailsRepository tripDetailsRepository;

  PutTripDetailsUseCase(this.tripDetailsRepository);

  Future<Either<String, DataRequest?>> execute(
      String id,
      String type,
      String comment,
      String latitude,
      String longitude,
      String place,
      String branch) {
    return tripDetailsRepository.putTrip(
        id, type, comment, latitude, longitude, place, branch);
  }
}
