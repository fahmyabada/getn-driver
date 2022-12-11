import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/domain/usecase/wallet/CreateRequestsTransactionUseCase.dart';
import 'package:getn_driver/domain/usecase/wallet/GetCountriesWalletUseCase.dart';
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
  var getCountriesWalletUseCase = getIt<GetCountriesWalletUseCase>();
  var createRequestsTransactionUseCase = getIt<CreateRequestsTransactionUseCase>();
  String typeScreen = "wallet";

  int currentIndex = 0;
  List<Country> countries = [];
  List<Data> wallet = [];
  List<Data> requests = [];
  int indexRequests = 1;
  int indexWallet = 1;
  String walletValue = "";
  String walletHold = "";
  String? walletFailure;
  bool loadingWallet = false;

  void editTypeScreen(int type){
    // typeScreen = type;
    currentIndex = 0;
    emit(EditTypeScreenWallet());
  }

  void getWallet(int index) async {
    if (index > 1) {
      getWalletUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateWallet2(value));
      });
    } else {
      loadingWallet = true;
      emit(WalletLoading());
      getWalletUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateWallet(value));
      });
    }
  }

  WalletState eitherLoadedOrErrorStateWallet(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      walletFailure = failure1;
      return WalletErrorState(failure1);
    }, (data) {
      wallet.clear();
      wallet.addAll(data!.data!);
      indexWallet = indexWallet + 1;
      walletValue = data.wallet!.toStringAsFixed(2);
      walletHold = data.holdWallet!.toStringAsFixed(2);
      loadingWallet = false;

      return WalletSuccessState(data);
    });
  }

  WalletState eitherLoadedOrErrorStateWallet2(
      Either<String, WalletModel?> data) {
    return data.fold((failure1) {
      return WalletErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > wallet.length) {
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
      emit(RequestsLoading());
      getRequestsWalletUseCase.execute(index).then((value) {
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
      if (data!.totalCount! > requests.length) {
        requests.addAll(data.data!);
        indexRequests = indexRequests + 1;
      }

      return RequestsSuccessState(data);
    });
  }

  void getCountries() async {
    emit(CountriesLoading());
    getCountriesWalletUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCountries(value));
    });
  }

  WalletState eitherLoadedOrErrorStateCountries(
      Either<String, List<Country>?> data) {
    return data.fold((failure1) {
      countries.clear();
      return CountriesErrorState(failure1);
    }, (data) {
      countries = data!;
      return CountriesSuccessState(data);
    });
  }

  void createRequestTransaction(String body) async {
    emit(CreateRequestLoading());
    createRequestsTransactionUseCase.execute(body).then((value) {
      emit(eitherLoadedOrErrorStateRequestTransaction(value));
    });
  }

  WalletState eitherLoadedOrErrorStateRequestTransaction(
      Either<String, Data?> data) {
    return data.fold((failure1) {
      return CreateRequestErrorState(failure1);
    }, (data) {
      return CreateRequestSuccessState(data!);
    });
  }
}
