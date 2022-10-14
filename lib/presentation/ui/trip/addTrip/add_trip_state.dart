part of 'add_trip_cubit.dart';

@immutable
abstract class AddTripState {}

class AddTripInitial extends AddTripState {}

class SearchLocationErrorState extends AddTripState {
  final String message;

  SearchLocationErrorState(this.message);
}

class SetSuggestionSelectedState extends AddTripState {
  final Predictions? data;

  SetSuggestionSelectedState(this.data);
}

class SetPlaceDetailsErrorState extends AddTripState {
  final String message;

  SetPlaceDetailsErrorState(this.message);
}

class SetPlaceDetailsSuccessState extends AddTripState {
  final Location? data;

  SetPlaceDetailsSuccessState(this.data);
}

class CreateTripInitial extends AddTripState {}

class CreateTripErrorState extends AddTripState {
  final String message;

  CreateTripErrorState(this.message);
}

class CreateTripSuccessState extends AddTripState {
  final Data? data;

  CreateTripSuccessState(this.data);
}