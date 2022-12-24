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

class RequestDetailsEditCancelInitial extends RequestDetailsState {}

class RequestDetailsLastTripErrorState extends RequestDetailsState {
  final String message;

  RequestDetailsLastTripErrorState(this.message);
}

class RequestDetailsLastTripSuccessState extends RequestDetailsState {
  final Request? data;
  final String? type;

  RequestDetailsLastTripSuccessState(this.data, this.type);
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

class RequestDetailsEditRejectInitial extends RequestDetailsState {}

class RequestDetailsEditRefresh extends RequestDetailsState {}

class RequestDetailsEditErrorState extends RequestDetailsState {
  final String message;
  final String? type;

  RequestDetailsEditErrorState(this.message, this.type);
}

class RequestDetailsEditSuccessState extends RequestDetailsState {
  final DataRequest? data;
  final String? type;

  RequestDetailsEditSuccessState(this.data, this.type);
}

class CurrentLocationLoading extends RequestDetailsState {}

class CurrentLocationSuccessState extends RequestDetailsState {
  final Position position;
  final String type;
  CurrentLocationSuccessState(this.position, this.type);
}

class CurrentLocationErrorState extends RequestDetailsState {
  final String error;

  CurrentLocationErrorState(this.error);
}