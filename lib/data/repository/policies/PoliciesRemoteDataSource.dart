import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/policies/PoliciesModel.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class PoliciesRemoteDataSource {
  Future<Either<String, PoliciesModel?>> getPolicies(String title);
}

class PoliciesRemoteDataSourceImpl implements PoliciesRemoteDataSource {
  @override
  Future<Either<String, PoliciesModel>> getPolicies(String title) async {
    try {
      return await DioHelper.getData(
        url: 'pages/slug/$title',
      ).then((value) {
        if (value.statusCode == 200) {
          if (PoliciesModel.fromJson(value.data).content!.en!.isNotEmpty) {
            return Right(PoliciesModel.fromJson(value.data!));
          } else {
            return Left("Not Found $title");
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
