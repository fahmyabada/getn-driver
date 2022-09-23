part of 'cubit.dart';

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

class RoleLoading extends SignState {}

class RoleErrorState extends SignState {
  final String message;

  RoleErrorState(this.message);
}

class RoleSuccessState extends SignState {
  final List<DataRole>? data;

  RoleSuccessState(this.data);
}

class SendOtpLoading extends SignState {}

class SendOtpSignInErrorState extends SignState {
  final String message;

  SendOtpSignInErrorState(this.message);
}

class SendOtpSignInSuccessState extends SignState {
  final SendOtpData data;

  SendOtpSignInSuccessState(this.data);
}

class SendOtpSignUpErrorState extends SignState {
  final String message;

  SendOtpSignUpErrorState(this.message);
}

class SendOtpSignUpSuccessState extends SignState {
  final SendOtpData data;

  SendOtpSignUpSuccessState(this.data);
}

class SendOtpErrorState extends SignState {
  final String message;

  SendOtpErrorState(this.message);
}

class SendOtpSuccessState extends SignState {
  final SendOtpData data;

  SendOtpSuccessState(this.data);
}

class RegisterLoading extends SignState {}

class RegisterErrorState extends SignState {
  final String message;

  RegisterErrorState(this.message);
}

class RegisterSuccessState extends SignState {
  final SignModel data;

  RegisterSuccessState(this.data);
}

class SignInLoading extends SignState {}

class SignInErrorState extends SignState {
  final String message;

  SignInErrorState(this.message);
}

class SignInSuccessState extends SignState {
  final SignModel data;

  SignInSuccessState(this.data);
}

class TermsSuccessState extends SignState {}

class DriverInformationLoading extends SignState {}
// class DriverInformationStringLoading extends SignState {}
// class DriverInformationBoolLoading extends SignState {}
