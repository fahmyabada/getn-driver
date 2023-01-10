part of 'setting_screen_cubit.dart';

@immutable
abstract class SettingScreenState {}

class SettingScreenInitial extends SettingScreenState {}

class DeleteAccountLoading extends SettingScreenState {}

class DeleteAccountErrorState extends SettingScreenState {
  final String message;

  DeleteAccountErrorState(this.message);
}

class DeleteAccountSuccessState extends SettingScreenState {
  final DeleteAccountModel? data;

  DeleteAccountSuccessState(this.data);
}