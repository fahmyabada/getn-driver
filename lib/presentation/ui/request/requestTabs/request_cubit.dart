import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/domain/usecase/request/GetRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestCurrentInitial());

  static RequestCubit get(context) => BlocProvider.of(context);

  var getRequestUseCase = getIt<GetRequestUseCase>();
  var putRequestUseCase = getIt<PutRequestUseCase>();
  String typeRequest = "current";
  TabController? tabController;

  List<DataRequest> requestCurrent = [];

  List<DataRequest> requestUpComing = [];
  int indexUpComing = 1;
  bool loadingUpComing = false;

  List<DataRequest> requestPast = [];
  int indexPast = 1;
  bool loadingPast = false;

  List<DataRequest> requestPending = [];
  int indexPending = 1;
  bool loadingPending = false;

  void getRequestCurrent(int index) async {
    emit(RequestCurrentInitial());
    var body = {
      "status": ["arrive", "coming", "start","on_my_way"],
      "page": index,
      "select-client": 'name image'
    };
    getRequestUseCase.execute(body).then((value) {
      emit(eitherLoadedOrErrorStateRequestCurrent(value));
    });
  }

  RequestState eitherLoadedOrErrorStateRequestCurrent(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      requestCurrent.clear();
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
      "status": "accept",
      "page": index,
      "sort": 'from.date:-1',
      "select-client": 'name image',
      "paymentStatus": "paid",
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

  RequestState eitherLoadedOrErrorStateRequestUpComing(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      requestUpComing.clear();
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        requestUpComing.clear();
        requestUpComing.addAll(data.data!);
        indexUpComing = indexUpComing + 1;
        loadingUpComing = true;
      }

      return RequestUpComingSuccessState(data.data);
    });
  }

  RequestState eitherLoadedOrErrorStateRequestUpComing2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= requestUpComing.length) {
          loadingUpComing = true;
          requestUpComing.addAll(data.data!);
          indexUpComing = indexUpComing + 1;
        } else {
          loadingUpComing = false;
        }
      }

      return RequestUpComingSuccessState(data.data);
    });
  }

  void getRequestPast(int index) async {
    var body = {
      "status": ["end", "cancel", "reject", "mid_pause"],
      "page": index,
      "sort": 'from.date:-1',
      "select-client": 'name image'
    };
    if (index > 1) {
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

  RequestState eitherLoadedOrErrorStateRequestPast(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      requestPast.clear();
      return RequestPastErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        requestPast.clear();
        requestPast.addAll(data.data!);
        // requestPast
        //     .sort((a, b) => a.referenceId! > b.referenceId! ? 1 : -1);
        indexPast = indexPast + 1;
        loadingPast = true;
      }

      return RequestPastSuccessState(data.data);
    });
  }

  RequestState eitherLoadedOrErrorStateRequestPast2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestPastErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= requestPast.length) {
          loadingPast = true;
          requestPast.addAll(data.data!);
          indexPast = indexPast + 1;
        } else {
          loadingPast = false;
        }
      }

      return RequestPastSuccessState(data.data);
    });
  }

  void getRequestPending(int index) async {
    var body = {
      "status": ["pending","accept"],
      "page": index,
      "sort": 'createdAt:-1',
      "select-client": 'name image',
      "paymentStatus": ["pending","need_confirm","failed"],
    };
    if (index > 1) {
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestPending2(value));
      });
    } else {
      emit(RequestPendingInitial());
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestPending(value));
      });
    }
  }

  RequestState eitherLoadedOrErrorStateRequestPending(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      requestPending.clear();
      return RequestPendingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        requestPending.clear();
        requestPending.addAll(data.data!);
        indexPending = indexPending + 1;
        loadingPending = true;
      }

      return RequestPendingSuccessState(data.data);
    });
  }

  RequestState eitherLoadedOrErrorStateRequestPending2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestPendingErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= requestPending.length) {
          loadingPending = true;
          requestPending.addAll(data.data!);
          indexPending = indexPending + 1;
        } else {
          loadingPending = false;
        }
      }
      return RequestPendingSuccessState(data.data);
    });
  }

  void editRequest(String id, String type, String comment) async {
    emit(RequestEditInitial());

    putRequestUseCase.execute(id, type, comment).then((value) {
      emit(eitherLoadedOrErrorStateRequestEdit(value));
    });
  }

  RequestState eitherLoadedOrErrorStateRequestEdit(
      Either<String, DataRequest?> data) {
    return data.fold((failure1) {
      return RequestEditErrorState(failure1);
    }, (data) {
      return RequestEditSuccessState(data);
    });
  }
}
