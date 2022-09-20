part of 'sign_cubit.dart';

@immutable
abstract class SignState {}

class SignInitial extends SignState {}

class CountriesLoading extends SignState {}

class CountriesErrorState extends SignState {
  final String message;

  CountriesErrorState(this.message);
}

class CountriesSuccessState extends SignState {
  final List<Data>? data;

  CountriesSuccessState(this.data);
}

class SendOtpLoading extends SignState {}

class SendOtpErrorState extends SignState {
  final String message;

  SendOtpErrorState(this.message);
}

class SendOtpSuccessState extends SignState {
  final SendOtpData data;

  SendOtpSuccessState(this.data);
}