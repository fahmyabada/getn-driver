import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class InfoPlaceRemoteDataSource {
  Future<Either<String, Data?>> getInfoPlace(String id);

  Future<Either<String, Data?>> getInfoBranch(String id);
}

class InfoPlaceRemoteDataSourceImpl implements InfoPlaceRemoteDataSource {
  @override
  Future<Either<String, Data?>> getInfoPlace(String id) async {
    try {
      return await DioHelper.getData(
        url: 'place/$id',
      ).then((value) {
        if (value.statusCode == 200) {
          if (Data.fromJson(value.data).id!.isNotEmpty) {
            return Right(Data.fromJson(value.data!));
          } else {
            return const Left("Not Found place details");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, Data?>> getInfoBranch(String id) async {
    try {
      return await DioHelper.getData(
        url: 'branch/$id',
      ).then((value) {
        if (value.statusCode == 200) {
          if (Data.fromJson(value.data).id!.isNotEmpty) {
            return Right(Data.fromJson(value.data!));
          } else {
            return const Left("Not Found branch details");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }
}
