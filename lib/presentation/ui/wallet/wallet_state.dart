part of 'wallet_cubit.dart';

@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletErrorState extends WalletState {
  final String message;

  WalletErrorState(this.message);
}

class WalletSuccessState extends WalletState {
  final WalletModel? data;

  WalletSuccessState(this.data);
}

class RequestsLoading extends WalletState {}

class RequestsErrorState extends WalletState {
  final String message;

  RequestsErrorState(this.message);
}

class RequestsSuccessState extends WalletState {
  final WalletModel? data;

  RequestsSuccessState(this.data);
}

class CountriesLoading extends WalletState {}

class CountriesErrorState extends WalletState {
  final String message;

  CountriesErrorState(this.message);
}

class CountriesSuccessState extends WalletState {
  final List<Country>? data;

  CountriesSuccessState(this.data);
}

class CreateRequestLoading extends WalletState {}

class CreateRequestErrorState extends WalletState {
  final String message;

  CreateRequestErrorState(this.message);
}

class CreateRequestSuccessState extends WalletState {
  final Data data;

  CreateRequestSuccessState(this.data);
}