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