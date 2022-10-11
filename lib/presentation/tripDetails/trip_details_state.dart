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

  TripDetailsEditErrorState(this.message);
}

class TripDetailsEditSuccessState extends TripDetailsInitial {
  final DataRequest? data;

  TripDetailsEditSuccessState(this.data);
}

class SearchLocationErrorState extends TripDetailsInitial {
  final String message;

  SearchLocationErrorState(this.message);
}

class SetSuggestionSelectedState extends TripDetailsInitial {
  final Predictions? data;

  SetSuggestionSelectedState(this.data);
}

class SetPlaceDetailsErrorState extends TripDetailsInitial {
  final String message;

  SetPlaceDetailsErrorState(this.message);
}

class SetPlaceDetailsSuccessState extends TripDetailsInitial {
  final Location? data;

  SetPlaceDetailsSuccessState(this.data);
}