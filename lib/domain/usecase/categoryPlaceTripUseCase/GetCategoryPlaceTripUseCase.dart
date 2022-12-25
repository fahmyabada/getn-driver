import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/CategoryPlaceTrip.dart';
import 'package:getn_driver/domain/repository/CategoryPlaceTripRepository.dart';

class GetCategoryPlaceTripUseCase {
  final CategoryPlaceTripRepository categoryPlaceTripRepository;

  GetCategoryPlaceTripUseCase(this.categoryPlaceTripRepository);

  Future<Either<String, CategoryPlaceTrip?>> execute(int index) {
    return categoryPlaceTripRepository.getCategoryPlace(index);
  }
}
