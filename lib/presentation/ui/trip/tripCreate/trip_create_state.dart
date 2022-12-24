part of 'trip_create_cubit.dart';

@immutable
abstract class TripCreateState {}

class AddTripInitial extends TripCreateState {}

class SearchLocationErrorState extends TripCreateState {
  final String message;

  SearchLocationErrorState(this.message);
}

class SetSuggestionSelectedState extends TripCreateState {
  final Predictions? data;

  SetSuggestionSelectedState(this.data);
}

class SetPlaceDetailsErrorState extends TripCreateState {
  final String message;

  SetPlaceDetailsErrorState(this.message);
}

class SetPlaceDetailsSuccessState extends TripCreateState {
  final Location? data;

  SetPlaceDetailsSuccessState(this.data);
}

class CreateTripInitial extends TripCreateState {}

class CreateTripErrorState extends TripCreateState {
  final String message;

  CreateTripErrorState(this.message);
}

class CreateTripSuccessState extends TripCreateState {
  final Data? data;

  CreateTripSuccessState(this.data);
}

class CanCreateTripErrorState extends TripCreateState {
  final String message;

  CanCreateTripErrorState(this.message);
}

class CanCreateTripSuccessState extends TripCreateState {
  final CanCreateTrip? data;

  CanCreateTripSuccessState(this.data);
}