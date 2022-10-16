import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/domain/repository/TripCreateRepository.dart';

class GetPlaceDetailsUseCase {
  final TripCreateRepository addTripRepository;

  GetPlaceDetailsUseCase(this.addTripRepository);

  Future<Either<String, PlaceDetails?>> execute(String placeId) {
    return addTripRepository.placeDetails(placeId);
  }
}
