import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashBoardRemoteDataSource {
  Future<Either<String, Request?>> getRequestCurrent(Map<String, dynamic> body);
}

class DashBoardRemoteDataSourceImpl implements DashBoardRemoteDataSource {
  @override
  Future<Either<String, Request?>> getRequestCurrent(
      Map<String, dynamic> body) async {
    try {
      return await DioHelper.getData(
              url: 'Request',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (Request.fromJson(value.data).data!.isNotEmpty) {
            return Right(Request.fromJson(value.data!));
          } else {
            return const Left("Not Found Roles");
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
