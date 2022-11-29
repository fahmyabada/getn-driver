import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';

class GetCurrentLocationTripUseCase {
  final TripDetailsRepository tripDetailsRepository;

  GetCurrentLocationTripUseCase(this.tripDetailsRepository);

  Future<Either<String, Position>> execute() {
    return tripDetailsRepository.getCurrentLocation();
  }
}
