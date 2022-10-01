import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RequestDetailsRemoteDataSource {
  Future<Either<String, DataRequest?>> getRequestDetails(String id);
}

class RequestDetailsRemoteDataSourceImpl
    implements RequestDetailsRemoteDataSource {
  @override
  Future<Either<String, DataRequest?>> getRequestDetails(String id) async {
    try {
      return await DioHelper.getData(
              url: 'Request/$id',
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (DataRequest.fromJson(value.data).id!.isNotEmpty) {
            return Right(DataRequest.fromJson(value.data!));
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
