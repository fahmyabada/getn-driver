import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class RecomendPlacesRemoteDataSource {
  Future<Either<String, RecomendPlaces?>> getPlaces(Map<String, dynamic> body);
}

class RecomendPlacesRemoteDataSourceImpl
    implements RecomendPlacesRemoteDataSource {
  @override
  Future<Either<String, RecomendPlaces?>> getPlaces(
      Map<String, dynamic> body) async {
    try {
      return await DioHelper.getData(
        url: 'place',
        query: body,
      ).then((value) {
        if (value.statusCode == 200) {
          if (RecomendPlaces.fromJson(value.data).data!.isNotEmpty) {
            return Right(RecomendPlaces.fromJson(value.data!));
          } else {
            return const Left("Not Found place");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }
}
