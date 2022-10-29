part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationErrorState extends NotificationState {
  final String message;

  NotificationErrorState(this.message);
}

class NotificationSuccessState extends NotificationState {
  final NotificationModel? data;

  NotificationSuccessState(this.data);
}