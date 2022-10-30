import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/notification/Data.dart';
import 'package:getn_driver/data/model/notification/NotificationModel.dart';
import 'package:getn_driver/domain/usecase/notifications/GetNotificationUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  static NotificationCubit get(context) => BlocProvider.of(context);

  var getNotificationUseCase = getIt<GetNotificationUseCase>();

  List<Data> notification = [];
  int indexNotification = 1;

  void getNotification(int index) async {
    if (index > 1) {
      getNotificationUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateNotification2(value));
      });
    } else {
      emit(NotificationLoading());
      getNotificationUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateNotification(value));
      });
    }
  }

  NotificationState eitherLoadedOrErrorStateNotification(
      Either<String, NotificationModel?> data) {
    return data.fold((failure1) {
      return NotificationErrorState(failure1);
    }, (data) {
        notification.clear();
        notification.addAll(data!.data!);
        indexNotification = indexNotification + 1;

      return NotificationSuccessState(data);
    });
  }

  NotificationState eitherLoadedOrErrorStateNotification2(
      Either<String, NotificationModel?> data) {
    return data.fold((failure1) {
      return NotificationErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > notification.length) {
        notification.addAll(data.data!);
        indexNotification = indexNotification + 1;
      }

      return NotificationSuccessState(data);
    });
  }
}
