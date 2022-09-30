import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/domain/usecase/dashboard/GetRequestUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'dash_board_state.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  DashBoardCubit() : super(RequestCurrentInitial());

  static DashBoardCubit get(context) => BlocProvider.of(context);

  var getRequestUseCase = getIt<GetRequestUseCase>();

  List<DataRequest> requestCurrent = [];

  List<DataRequest> requestUpComing = [];
  int indexUpComing = 0;
  bool loadingUpComing = false;

  List<DataRequest> requestPast = [];
  int indexPast = 0;
  bool loadingPast = false;

  void getRequestCurrent(int index) async {
    emit(RequestCurrentInitial());
    var body = {
      "status": ["arrive", "coming", "start"],
      "page": index
    };
    getRequestUseCase.execute(body).then((value) {
      emit(eitherLoadedOrErrorStateRequestCurrent(value));
    });
  }

  DashBoardState eitherLoadedOrErrorStateRequestCurrent(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestCurrentErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        requestCurrent.clear();
        requestCurrent = data.data!;
      }
      return RequestCurrentSuccessState(data.data);
    });
  }

  void getRequestUpComing(int index) async {
    var body = {
      "status": ["pending", "accept"],
      "page": index
    };
    if (index > 1) {
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestUpComing2(value));
      });
    } else {
      // print("indexlll*********** ");
      emit(RequestUpComingInitial());
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestUpComing(value));
      });
    }
  }

  DashBoardState eitherLoadedOrErrorStateRequestUpComing(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        requestUpComing.clear();
        requestUpComing.addAll(data.data!);
        requestUpComing
            .sort((a, b) => a.referenceId! > b.referenceId! ? 1 : -1);
        indexUpComing = indexUpComing + 1;
        loadingUpComing = true;
      }

      return RequestCurrentSuccessState(data.data);
    });
  }

  DashBoardState eitherLoadedOrErrorStateRequestUpComing2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= requestUpComing.length) {
          loadingUpComing = true;
          requestUpComing.addAll(data.data!);
          requestUpComing
              .sort((a, b) => a.referenceId! > b.referenceId! ? 1 : -1);
          indexUpComing = indexUpComing + 1;
        } else {
          loadingUpComing = false;
        }
      }

      return RequestCurrentSuccessState(data.data);
    });
  }


  void getRequestPast(int index) async {
    var body = {
      "status": ["end", "cancel", "reject"],
      "page": index
    };
    if (index > 1) {
      print('_controllerPast*******${requestPast.length}');
      print('_controllerPast22*******${index}');
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestPast2(value));
      });
    } else {
      emit(RequestPastInitial());
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestPast(value));
      });
    }
  }

  DashBoardState eitherLoadedOrErrorStateRequestPast(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        requestPast.clear();
        requestPast.addAll(data.data!);
        requestPast
            .sort((a, b) => a.referenceId! > b.referenceId! ? 1 : -1);
        indexPast = indexPast + 1;
        loadingPast = true;
      }

      return RequestCurrentSuccessState(data.data);
    });
  }

  DashBoardState eitherLoadedOrErrorStateRequestPast2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= requestPast.length) {
          loadingPast = true;
          requestPast.addAll(data.data!);
          requestPast
              .sort((a, b) => a.referenceId! > b.referenceId! ? 1 : -1);
          indexPast = indexPast + 1;
        } else {
          loadingPast = false;
        }
      }

      return RequestCurrentSuccessState(data.data);
    });
  }


}
