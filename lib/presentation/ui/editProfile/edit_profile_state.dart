part of 'edit_profile_cubit.dart';

@immutable
abstract class EditProfileState {}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileErrorState extends EditProfileState {
  final String message;

  EditProfileErrorState(this.message);
}

class EditProfileSuccessState extends EditProfileState {
  final EditProfileModel? data;

  EditProfileSuccessState(this.data);
}

class CountriesLoading extends EditProfileState {}

class CountriesErrorState extends EditProfileState {
  final String message;

  CountriesErrorState(this.message);
}

class CountriesSuccessState extends EditProfileState {
  final List<Country>? data;

  CountriesSuccessState(this.data);
}

class CityLoading extends EditProfileState {}

class CityErrorState extends EditProfileState {
  final String message;

  CityErrorState(this.message);
}

class CitySuccessState extends EditProfileState {
  final List<Country>? data;

  CitySuccessState(this.data);
}

class AreaLoading extends EditProfileState {}

class AreaErrorState extends EditProfileState {
  final String message;

  AreaErrorState(this.message);
}

class AreaSuccessState extends EditProfileState {
  final List<Country>? data;

  AreaSuccessState(this.data);
}

class EditLoading extends EditProfileState {}

class EditErrorState extends EditProfileState {
  final String message;

  EditErrorState(this.message);
}

class EditSuccessState extends EditProfileState {
  final SignModel data;

  EditSuccessState(this.data);
}