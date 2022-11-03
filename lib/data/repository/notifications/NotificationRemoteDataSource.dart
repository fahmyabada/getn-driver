import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/notification/NotificationModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationRemoteDataSource {
  Future<Either<String, NotificationModel?>> getNotification(int index);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {

  @override
  Future<Either<String, NotificationModel?>> getNotification(int index) async{
    try {
      var body = {
        "sort": "createdAt:-1",
        "page": index,
        "app": "driver-app",
      };
      return await DioHelper.getData(
          url: 'notification',
          query: body,
          token: getIt<SharedPreferences>().getString("token")
      ).then((value) {
        if (value.statusCode == 200) {
          return Right(NotificationModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }
}
