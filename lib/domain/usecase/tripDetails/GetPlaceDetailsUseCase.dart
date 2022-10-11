import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';

class GetPlaceDetailsUseCase {
  final TripDetailsRepository tripDetailsRepository;

  GetPlaceDetailsUseCase(this.tripDetailsRepository);

  Future<Either<String, PlaceDetails?>> execute(String placeId) {
    return tripDetailsRepository.placeDetails(placeId);
  }
}
