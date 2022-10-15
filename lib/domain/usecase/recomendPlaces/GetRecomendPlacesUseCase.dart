import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/domain/repository/RecomendPlaceRepository.dart';

class GetRecomendPlacesUseCase {
  final RecomendPlaceRepository recomendPlaceRepository;

  GetRecomendPlacesUseCase(this.recomendPlaceRepository);

  Future<Either<String, RecomendPlaces?>> execute(Map<String, dynamic> body) {
    return recomendPlaceRepository.getPlaces(body);
  }
}
