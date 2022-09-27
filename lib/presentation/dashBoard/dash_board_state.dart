part of 'dash_board_cubit.dart';

@immutable
abstract class DashBoardState {}

class RequestInitial extends DashBoardState {}

class RequestErrorState extends DashBoardState {
  final String message;

  RequestErrorState(this.message);
}

class RequestSuccessState extends DashBoardState {
  final List<DataRole>? data;

  RequestSuccessState(this.data);
}