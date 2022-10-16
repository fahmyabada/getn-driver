part of 'info_branch_cubit.dart';

@immutable
abstract class InfoBranchState {}

class InfoBranchInitial extends InfoBranchState {}

class GetInfoPlaceInitial extends InfoBranchState {}

class GetInfoPlaceErrorState extends InfoBranchState {
  final String message;

  GetInfoPlaceErrorState(this.message);
}

class GetInfoPlaceSuccessState extends InfoBranchState {
  final Data? data;

  GetInfoPlaceSuccessState(this.data);
}

class GetBranchesInitial extends InfoBranchState {}

class GetBranchesErrorState extends InfoBranchState {
  final String message;

  GetBranchesErrorState(this.message);
}

class GetBranchesSuccessState extends InfoBranchState {
  final List<Data>? data;

  GetBranchesSuccessState(this.data);
}