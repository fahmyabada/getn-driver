part of 'request_cubit.dart';

@immutable
abstract class RequestState {}

class RequestCurrentInitial extends RequestState {}

class RequestCurrentErrorState extends RequestState {
  final String message;

  RequestCurrentErrorState(this.message);
}

class RequestCurrentSuccessState extends RequestState {
  final List<DataRequest>? data;

  RequestCurrentSuccessState(this.data);
}

class RequestUpComingInitial extends RequestState {}

class RequestUpComingErrorState extends RequestState {
  final String message;

  RequestUpComingErrorState(this.message);
}

class RequestUpComingSuccessState extends RequestState {
  final List<DataRequest>? data;

  RequestUpComingSuccessState(this.data);
}

class RequestPastInitial extends RequestState {}

class RequestPastErrorState extends RequestState {
  final String message;

  RequestPastErrorState(this.message);
}

class RequestPastSuccessState extends RequestState {
  final List<DataRequest>? data;

  RequestPastSuccessState(this.data);
}

class RequestPendingInitial extends RequestState {}

class RequestPendingErrorState extends RequestState {
  final String message;

  RequestPendingErrorState(this.message);
}

class RequestPendingSuccessState extends RequestState {
  final List<DataRequest>? data;

  RequestPendingSuccessState(this.data);
}

class RequestEditErrorState extends RequestState {
  final String message;
  final String type;

  RequestEditErrorState(this.message, this.type);
}

class RequestEditSuccessState extends RequestState {
  final DataRequest? data;

  RequestEditSuccessState(this.data);
}

class SignOutErrorState extends RequestState {
  final String message;

  SignOutErrorState(this.message);
}

class SignOutSuccessState extends RequestState {
  final String? data;

  SignOutSuccessState(this.data);
}
