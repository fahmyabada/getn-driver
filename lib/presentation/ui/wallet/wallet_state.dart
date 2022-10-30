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