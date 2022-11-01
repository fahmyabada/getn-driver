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
  final List<Country>? data;

  CountriesSuccessState(this.data);
}

class CityLoading extends SignState {}

class CityErrorState extends SignState {
  final String message;

  CityErrorState(this.message);
}

class CitySuccessState extends SignState {
  final List<Country>? data;

  CitySuccessState(this.data);
}

class AreaLoading extends SignState {}

class AreaErrorState extends SignState {
  final String message;

  AreaErrorState(this.message);
}

class AreaSuccessState extends SignState {
  final List<Country>? data;

  AreaSuccessState(this.data);
}

class CarModelErrorState extends SignState {
  final String message;

  CarModelErrorState(this.message);
}

class CarModelSuccessState extends SignState {
  final List<category.Data>? data;

  CarModelSuccessState(this.data);
}

class CarSubCategoryErrorState extends SignState {
  final String message;

  CarSubCategoryErrorState(this.message);
}

class CarSubCategorySuccessState extends SignState {
  final List<category.Data>? data;

  CarSubCategorySuccessState(this.data);
}

class ColorErrorState extends SignState {
  final String message;

  ColorErrorState(this.message);
}

class ColorSuccessState extends SignState {
  final List<category.Data>? data;

  ColorSuccessState(this.data);
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

class CarCreateLoading extends SignState {}

class CarCreateErrorState extends SignState {
  final String message;

  CarCreateErrorState(this.message);
}

class CarCreateSuccessState extends SignState {
  final CarRegisterationModel? data;

  CarCreateSuccessState(this.data);
}

class EditLoading extends SignState {}

class EditErrorState extends SignState {
  final String message;

  EditErrorState(this.message);
}

class EditSuccessState extends SignState {
  final EditProfileModel data;

  EditSuccessState(this.data);
}

class TermsSuccessState extends SignState {}

class DriverInformationLoading extends SignState {}
// class DriverInformationStringLoading extends SignState {}
// class DriverInformationBoolLoading extends SignState {}
