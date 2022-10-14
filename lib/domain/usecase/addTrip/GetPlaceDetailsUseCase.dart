import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/domain/repository/AddTripRepository.dart';

class GetPlaceDetailsUseCase {
  final AddTripRepository addTripRepository;

  GetPlaceDetailsUseCase(this.addTripRepository);

  Future<Either<String, PlaceDetails?>> execute(String placeId) {
    return addTripRepository.placeDetails(placeId);
  }
}
