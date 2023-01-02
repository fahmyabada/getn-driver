part of 'packages_screen_cubit.dart';

@immutable
abstract class PackagesScreenState {}

class PackagesScreenInitial extends PackagesScreenState {}

class PackagesLoading extends PackagesScreenState {}

class PackagesErrorState extends PackagesScreenState {
  final String message;

  PackagesErrorState(this.message);
}

class PackagesSuccessState extends PackagesScreenState {
  final PackagesModel? data;

  PackagesSuccessState(this.data);
}