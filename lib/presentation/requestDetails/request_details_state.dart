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

class TripsInitial extends RequestDetailsState {}

class TripsErrorState extends RequestDetailsState {
  final String message;

  TripsErrorState(this.message);
}

class TripsSuccessState extends RequestDetailsState {
  final Trips? data;

  TripsSuccessState(this.data);
}

class RequestDetailsEditInitial extends RequestDetailsState {}

class RequestDetailsEditErrorState extends RequestDetailsState {
  final String message;

  RequestDetailsEditErrorState(this.message);
}

class RequestDetailsEditSuccessState extends RequestDetailsState {
  final DataRequest? data;

  RequestDetailsEditSuccessState(this.data);
}