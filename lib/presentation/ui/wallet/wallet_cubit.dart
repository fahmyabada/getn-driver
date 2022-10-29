import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/domain/usecase/wallet/GetWalletUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

import '../../../data/model/wallet/Data.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletInitial());

  static WalletCubit get(context) => BlocProvider.of(context);

  var getWalletUseCase = getIt<GetWalletUseCase>();

  List<Data> wallet = [];
  int indexWallet = 1;
  bool loadingWallet = false;
  String walletValue = "";
  String walletHold = "";

  void getWallet(int index) async {
    if (index > 1) {
      getWalletUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateWallet2(value));
      });
    } else {
      emit(WalletLoading());
      getWalletUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateWallet(value));
      });
    }
  }

  WalletState eitherLoadedOrErrorStateWallet(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      wallet.clear();
      return WalletErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        wallet.clear();
        wallet.addAll(data.data!);
        indexWallet = indexWallet + 1;
        loadingWallet = true;
      }
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
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= wallet.length) {
          loadingWallet = true;
          wallet.addAll(data.data!);
          indexWallet = indexWallet + 1;
        } else {
          loadingWallet = false;
        }
      }

      return WalletSuccessState(data);
    });
  }
}
