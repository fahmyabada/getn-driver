import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';

abstract class InfoPlaceRepository {
  Future<Either<String, Data?>> getInfoPlace(String id, String type);
}
