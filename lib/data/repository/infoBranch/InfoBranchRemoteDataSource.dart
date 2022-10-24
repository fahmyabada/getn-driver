import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class InfoBranchRemoteDataSource {
  Future<Either<String, Data?>> getInfoPlace(String id);

  Future<Either<String, RecomendPlaces?>> getBranches(Map<String, dynamic> body);
}

class InfoBranchRemoteDataSourceImpl implements InfoBranchRemoteDataSource {
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
    }  catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, RecomendPlaces?>> getBranches(
      Map<String, dynamic> body) async {
    try {
      return await DioHelper.getData(
        url: 'branch',
        query: body,
      ).then((value) {
        if (value.statusCode == 200) {
          if (RecomendPlaces.fromJson(value.data).data!.isNotEmpty) {
            return Right(RecomendPlaces.fromJson(value.data!));
          } else {
            return const Left("Not Found branch");
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
