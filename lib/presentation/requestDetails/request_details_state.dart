part of 'request_details_cubit.dart';

@immutable
abstract class RequestDetailsState {}

class RequestDetailsInitial extends RequestDetailsState {}

class RequestDetailsErrorState extends RequestDetailsState {
  final String message;

  RequestDetailsErrorState(this.message);
}

class RequestDetailsSuccessState extends RequestDetailsState {
  final DataRequest? data;

  RequestDetailsSuccessState(this.data);
}