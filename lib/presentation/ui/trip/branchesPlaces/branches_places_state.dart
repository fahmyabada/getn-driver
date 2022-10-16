part of 'branches_places_cubit.dart';

@immutable
abstract class BranchesPlacesState {}

class BranchesPlacesInitial extends BranchesPlacesState {}

class GetBranchesInitial extends BranchesPlacesState {}

class GetBranchesErrorState extends BranchesPlacesState {
  final String message;

  GetBranchesErrorState(this.message);
}

class GetBranchesSuccessState extends BranchesPlacesState {
  final List<Data>? data;

  GetBranchesSuccessState(this.data);
}