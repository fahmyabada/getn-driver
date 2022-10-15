part of 'recomend_places_cubit.dart';

@immutable
abstract class RecomendPlacesState {}

class RecomendPlacesInitial extends RecomendPlacesState {}

class GetPlacesInitial extends RecomendPlacesState {}

class GetPlacesErrorState extends RecomendPlacesState {
  final String message;

  GetPlacesErrorState(this.message);
}

class GetPlacesSuccessState extends RecomendPlacesState {
  final List<Data>? data;

  GetPlacesSuccessState(this.data);
}