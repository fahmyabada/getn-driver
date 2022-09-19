part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class CountriesLoading extends SignInState {}

class CountriesErrorState extends SignInState {
  final String message;

  CountriesErrorState(this.message);
}

class CountriesSuccessState extends SignInState {
  final List<Data>? data;

  CountriesSuccessState(this.data);
}

class SendOtpLoading extends SignInState {}

class SendOtpErrorState extends SignInState {
  final String message;

  SendOtpErrorState(this.message);
}

class SendOtpSuccessState extends SignInState {
  final SendOtpData data;

  SendOtpSuccessState(this.data);
}