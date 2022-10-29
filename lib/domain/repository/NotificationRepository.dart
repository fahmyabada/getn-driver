import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/notification/NotificationModel.dart';

abstract class NotificationRepository {
  Future<Either<String, NotificationModel?>> getNotification(int index);
}
