part of 'category_place_trip_screen_cubit.dart';

@immutable
abstract class CategoryPlaceTripScreenState {}

class CategoryPlaceTripScreenInitial extends CategoryPlaceTripScreenState {}

class CategoryPlaceTripInitial extends CategoryPlaceTripScreenState {}

class CategoryPlaceTripErrorState extends CategoryPlaceTripScreenState {
  final String message;

  CategoryPlaceTripErrorState(this.message);
}

class CategoryPlaceTripSuccessState extends CategoryPlaceTripScreenState {
  final List<Data>? data;

  CategoryPlaceTripSuccessState(this.data);
}