part of 'info_place_cubit.dart';

@immutable
abstract class InfoPlaceState {}

class InfoPlaceInitial extends InfoPlaceState {}

class GetInfoInitial extends InfoPlaceState {}

class GetInfoErrorState extends InfoPlaceState {
  final String message;

  GetInfoErrorState(this.message);
}

class GetInfoSuccessState extends InfoPlaceState {
  final Data? data;

  GetInfoSuccessState(this.data);
}