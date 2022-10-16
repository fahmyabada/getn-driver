import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/domain/repository/TripCreateRepository.dart';

class GetSearchLocationUseCase {
  final TripCreateRepository addTripRepository;

  GetSearchLocationUseCase(this.addTripRepository);

  Future<Either<String, PredictionsPlaceSearch?>> execute(String text) {
    return addTripRepository.searchLocation(text);
  }
}
