import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/domain/usecase/wallet/GetRequestsWalletUseCase.dart';
import 'package:getn_driver/domain/usecase/wallet/GetWalletUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

import '../../../data/model/wallet/Data.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  static WalletCubit get(context) => BlocProvider.of(context);

  var getWalletUseCase = getIt<GetWalletUseCase>();
  var getRequestsWalletUseCase = getIt<GetRequestsWalletUseCase>();

  List<Data> wallet = [];
  List<Data> requests = [];
  int indexRequests = 1;
  int indexWallet = 1;
  String walletValue = "";
  String walletHold = "";
  bool loadingWallet = false;
  bool loadingRequests = false;

  void getWallet(int index) async {
    if (index > 1) {
      getWalletUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateWallet2(value));
      });
    } else {
      loadingWallet = true;
      emit(WalletLoading());
      getWalletUseCase.execute(index).then((value) {
        loadingWallet = false;
        emit(eitherLoadedOrErrorStateWallet(value));
      });
    }
  }

  WalletState eitherLoadedOrErrorStateWallet(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      return WalletErrorState(failure1);
    }, (data) {
      wallet.clear();
      wallet.addAll(data!.data!);
      indexWallet = indexWallet + 1;
      walletValue = data.wallet!.toStringAsFixed(1);
      walletHold = data.holdWallet.toString();

      return WalletSuccessState(data);
    });
  }

  WalletState eitherLoadedOrErrorStateWallet2(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      return WalletErrorState(failure1);
    }, (data) {
      if (data!.totalCount! >= wallet.length) {
        wallet.addAll(data.data!);
        indexWallet = indexWallet + 1;
      }

      return WalletSuccessState(data);
    });
  }

  void getRequests(int index) async {
    if (index > 1) {
      getRequestsWalletUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateRequests2(value));
      });
    } else {
      loadingRequests = true;
      emit(RequestsLoading());
      getRequestsWalletUseCase.execute(index).then((value) {
        loadingRequests = false;
        emit(eitherLoadedOrErrorStateRequests(value));
      });
    }
  }

  WalletState eitherLoadedOrErrorStateRequests(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      return RequestsErrorState(failure1);
    }, (data) {
      requests.clear();
      requests.addAll(data!.data!);
      indexRequests = indexRequests + 1;

      return RequestsSuccessState(data);
    });
  }

  WalletState eitherLoadedOrErrorStateRequests2(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      return RequestsErrorState(failure1);
    }, (data) {
      if (data!.totalCount! >= requests.length) {
        requests.addAll(data.data!);
        indexRequests = indexRequests + 1;
      }

      return RequestsSuccessState(data);
    });
  }
}
