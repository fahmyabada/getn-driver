part of 'policies_cubit.dart';

@immutable
abstract class PoliciesState {}

class PoliciesInitial extends PoliciesState {}

class PoliciesLoading extends PoliciesState {}

class PoliciesErrorState extends PoliciesState {
  final String message;

  PoliciesErrorState(this.message);
}

class PoliciesSuccessState extends PoliciesState {
  final PoliciesModel? data;

  PoliciesSuccessState(this.data);
}