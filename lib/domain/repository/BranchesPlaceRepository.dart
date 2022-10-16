import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';

abstract class BranchesPlaceRepository {
  Future<Either<String, RecomendPlaces?>> getBranches(Map<String, dynamic> body);

}
