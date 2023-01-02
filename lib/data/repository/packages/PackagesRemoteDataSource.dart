import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/packages/PackagesModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PackagesRemoteDataSource {
  Future<Either<String, PackagesModel?>> getPackages(
      int index, String carCategory);
}

class PackagesRemoteDataSourceImpl implements PackagesRemoteDataSource {
  @override
  Future<Either<String, PackagesModel?>> getPackages(
      int index, String carCategory) async {
    try {
      var body = {
        "page": index,
        "carCategory": carCategory,
      };
      return await DioHelper.getData(
              url: 'package',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(PackagesModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }
}
