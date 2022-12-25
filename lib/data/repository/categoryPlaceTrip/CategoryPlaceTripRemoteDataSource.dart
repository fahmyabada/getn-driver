import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/CategoryPlaceTrip.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class CategoryPlaceTripRemoteDataSource {
  Future<Either<String, CategoryPlaceTrip?>> getCategoryPlace(int index);
}

class CategoryPlaceTripRemoteDataSourceImpl
    implements CategoryPlaceTripRemoteDataSource {
  @override
  Future<Either<String, CategoryPlaceTrip?>> getCategoryPlace(int index) async {
    try {
      var body = {
        "page": index,
        "select": 'title icon',
      };

      return await DioHelper.getData(
        url: 'category',
        query: body,
      ).then((value) {
        if (value.statusCode == 200) {
          return Right(CategoryPlaceTrip.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }
}
