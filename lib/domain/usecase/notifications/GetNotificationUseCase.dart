import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/notification/NotificationModel.dart';
import 'package:getn_driver/domain/repository/NotificationRepository.dart';

class GetNotificationUseCase {
  final NotificationRepository notificationRepository;

  GetNotificationUseCase(this.notificationRepository);

  Future<Either<String, NotificationModel?>> execute(int index) {
    return notificationRepository.getNotification(index);
  }
}
