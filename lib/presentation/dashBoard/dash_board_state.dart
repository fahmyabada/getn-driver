part of 'dash_board_cubit.dart';

@immutable
abstract class DashBoardState {}

class RequestCurrentInitial extends DashBoardState {}

class RequestCurrentErrorState extends DashBoardState {
  final String message;

  RequestCurrentErrorState(this.message);
}

class RequestCurrentSuccessState extends DashBoardState {
  final List<DataRequest>? data;

  RequestCurrentSuccessState(this.data);
}

class RequestUpComingInitial extends DashBoardState {}

class RequestUpComingErrorState extends DashBoardState {
  final String message;

  RequestUpComingErrorState(this.message);
}

class RequestUpComingSuccessState extends DashBoardState {
  final List<DataRequest>? data;

  RequestUpComingSuccessState(this.data);
}

class RequestPastInitial extends DashBoardState {}

class RequestPastErrorState extends DashBoardState {
  final String message;

  RequestPastErrorState(this.message);
}

class RequestPastSuccessState extends DashBoardState {
  final List<DataRequest>? data;

  RequestPastSuccessState(this.data);
}