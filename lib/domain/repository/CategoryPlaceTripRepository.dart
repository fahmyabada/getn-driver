import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/CategoryPlaceTrip.dart';

abstract class CategoryPlaceTripRepository {
  Future<Either<String, CategoryPlaceTrip?>> getCategoryPlace(int index);
}
