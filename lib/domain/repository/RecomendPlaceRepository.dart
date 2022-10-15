import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';

abstract class RecomendPlaceRepository {
  Future<Either<String, RecomendPlaces?>> getPlaces(Map<String, dynamic> body);

}
