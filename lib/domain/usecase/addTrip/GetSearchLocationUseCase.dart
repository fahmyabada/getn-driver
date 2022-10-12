import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';

class GetSearchLocationUseCase {
  final TripDetailsRepository tripDetailsRepository;

  GetSearchLocationUseCase(this.tripDetailsRepository);

  Future<Either<String, PredictionsPlaceSearch?>> execute(String text) {
    return tripDetailsRepository.searchLocation(text);
  }
}
