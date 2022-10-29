import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/notification/NotificationModel.dart';
import 'package:getn_driver/data/repository/notifications/NotificationRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/NotificationRepository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoryImpl(this.notificationRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, NotificationModel?>> getNotification(int index) async{
    if (await networkInfo.isConnected) {
      return await notificationRemoteDataSource.getNotification(index).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
    }
  }
}
