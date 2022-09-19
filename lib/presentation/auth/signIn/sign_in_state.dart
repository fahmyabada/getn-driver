part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInErrorState extends SignInState {
  final String message;

  SignInErrorState(this.message);
}

class SignInSuccessState extends SignInState {
  final List<Data>? data;

  SignInSuccessState(this.data);
}