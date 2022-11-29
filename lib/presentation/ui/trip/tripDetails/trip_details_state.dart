part of 'trip_details_cubit.dart';

@immutable
abstract class TripDetailsState {}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsErrorState extends TripDetailsInitial {
  final String message;

  TripDetailsErrorState(this.message);
}

class TripDetailsSuccessState extends TripDetailsInitial {
  final Data? data;

  TripDetailsSuccessState(this.data);
}

class TripDetailsEditInitial extends TripDetailsInitial {}


class TripDetailsEditErrorState extends TripDetailsInitial {
  final String message;
  final String? type;

  TripDetailsEditErrorState(this.message, this.type);
}

class TripDetailsEditSuccessState extends TripDetailsInitial {
  final DataRequest? data;
  final String? type;

  TripDetailsEditSuccessState(this.data, this.type);
}

class GoogleMapInitial extends TripDetailsInitial {}

class GoogleMapErrorState extends TripDetailsInitial {
  final String message;

  GoogleMapErrorState(this.message);
}

class GoogleMapSuccessState extends TripDetailsInitial {
  final APIResultModel? test;

  GoogleMapSuccessState(this.test);
}

class CurrentLocationTripLoading extends TripDetailsInitial {}

class CurrentLocationTripSuccessState extends TripDetailsInitial {
  final Position position;

  CurrentLocationTripSuccessState(this.position);
}

class CurrentLocationTripErrorState extends TripDetailsInitial {
  final String error;

  CurrentLocationTripErrorState(this.error);
}