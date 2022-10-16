import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';

abstract class InfoBranchRepository {
  Future<Either<String, Data?>> getInfoPlace(String id);

  Future<Either<String, RecomendPlaces?>> getBranches(Map<String, dynamic> body);
}
