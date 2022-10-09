import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';

class GetTripDetailsUseCase {
  final TripDetailsRepository tripDetailsRepository;

  GetTripDetailsUseCase(this.tripDetailsRepository);

  Future<Either<String, Data?>> execute(String id) {
    return tripDetailsRepository.getTripDetails(id);
  }
}
