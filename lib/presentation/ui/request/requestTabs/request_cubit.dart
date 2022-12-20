import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/domain/usecase/request/GetProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/request/GetRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/request/SignOutUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestCurrentInitial());

  static RequestCubit get(context) => BlocProvider.of(context);

  var getRequestUseCase = getIt<GetRequestUseCase>();
  var putRequestUseCase = getIt<PutRequestUseCase>();
  var signOutUseCase = getIt<SignOutUseCase>();
  var getProfileUseCase = getIt<GetProfileUseCase>();

  List<DataRequest> requestCurrent = [];

  List<DataRequest> requestUpComing = [];
  int indexUpComing = 1;

  List<DataRequest> requestPast = [];
  int indexPast = 1;

  List<DataRequest> requestPending = [];
  int indexPending = 1;

  bool loadingCurrent = false;
  bool loadingPast = false;
  bool loadingUpComing = false;

  // pending
  bool loadingPending = false;
  bool loadingEditPending = false;

  bool tabControllerChanged = false;

  TabController? tabController;

  String typeRequest = "current";

  Future<void> editProfile() async {
    getProfileUseCase.execute();
  }

  void getRequestCurrent(int index) async {
    loadingCurrent = true;
    emit(RequestCurrentInitial());
    var body = {
      "status": ["arrive", "coming", "start", "on_my_way"],
      "page": index,
      "select-client": 'name image',
      "select-carCategory": 'oneKMPoints points',
    };
    getRequestUseCase.execute(body).then((value) {
      loadingCurrent = false;
      emit(eitherLoadedOrErrorStateRequestCurrent(value));
    });
  }

  RequestState eitherLoadedOrErrorStateRequestCurrent(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestCurrentErrorState(failure1);
    }, (data) {
      requestCurrent.clear();
      requestCurrent = data!.data!;
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
      "select-carCategory": 'oneKMPoints points',
    };
    if (index > 1) {
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestUpComing2(value));
      });
    } else {
      // print("indexlll*********** ");
      loadingUpComing = true;
      emit(RequestUpComingInitial());
      getRequestUseCase.execute(body).then((value) {
        loadingUpComing = false;
        emit(eitherLoadedOrErrorStateRequestUpComing(value));
      });
    }
  }

  RequestState eitherLoadedOrErrorStateRequestUpComing(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      requestUpComing.clear();
      requestUpComing.addAll(data!.data!);
      indexUpComing = indexUpComing + 1;
      return RequestUpComingSuccessState(data.data);
    });
  }

  RequestState eitherLoadedOrErrorStateRequestUpComing2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestUpComingErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > requestUpComing.length) {
        requestUpComing.addAll(data.data!);
        indexUpComing = indexUpComing + 1;
      }
      return RequestUpComingSuccessState(data.data);
    });
  }

  void getRequestPast(int index) async {
    var body = {
      "status": ["end", "cancel", "reject", "mid_pause"],
      "page": index,
      "sort": 'from.date:-1',
      "select-client": 'name image',
      "select-carCategory": 'oneKMPoints points',
    };
    print("getRequestPast************* $index");
    if (index > 1) {
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestPast2(value));
      });
    } else {
      loadingPast = true;
      emit(RequestPastInitial());
      getRequestUseCase.execute(body).then((value) {
        loadingPast = false;
        emit(eitherLoadedOrErrorStateRequestPast(value));
      });
    }
  }

  RequestState eitherLoadedOrErrorStateRequestPast(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestPastErrorState(failure1);
    }, (data) {
      requestPast.clear();
      requestPast.addAll(data!.data!);
      // requestPast
      //     .sort((a, b) => a.referenceId! > b.referenceId! ? 1 : -1);
      indexPast = indexPast + 1;
      return RequestPastSuccessState(data.data);
    });
  }

  RequestState eitherLoadedOrErrorStateRequestPast2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestPastErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > requestPast.length) {
        requestPast.addAll(data.data!);
        indexPast = indexPast + 1;
      }
      return RequestPastSuccessState(data.data);
    });
  }

  void getRequestPending(int index) async {
    var body = {
      "status": ["pending", "accept"],
      "page": index,
      "sort": 'createdAt:-1',
      "select-client": 'name image',
      "paymentStatus": ["pending", "need_confirm", "failed"],
      "select-carCategory": 'oneKMPoints points',
    };
    if (index > 1) {
      getRequestUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateRequestPending2(value));
      });
    } else {
      loadingPending = true;
      emit(RequestPendingInitial());
      getRequestUseCase.execute(body).then((value) {
        loadingPending = false;
        emit(eitherLoadedOrErrorStateRequestPending(value));
      });
    }
  }

  RequestState eitherLoadedOrErrorStateRequestPending(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestPendingErrorState(failure1);
    }, (data) {
      requestPending.clear();
      requestPending.addAll(data!.data!);
      indexPending = indexPending + 1;
      return RequestPendingSuccessState(data.data);
    });
  }

  RequestState eitherLoadedOrErrorStateRequestPending2(
      Either<String, Request?> data) {
    return data.fold((failure1) {
      return RequestPendingErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > requestPending.length) {
        requestPending.addAll(data.data!);
        indexPending = indexPending + 1;
      }
      return RequestPendingSuccessState(data.data);
    });
  }

  void editRequest(String id, String type, String comment) async {
    if (type == "accept") {
      loadingEditPending = true;
    }
    putRequestUseCase.execute(id, type, comment).then((value) {
      if (type == "accept") {
        loadingEditPending = false;
      }
      emit(eitherLoadedOrErrorStateRequestEdit(value, type));
    });
  }

  RequestState eitherLoadedOrErrorStateRequestEdit(
      Either<String, DataRequest?> data, String type) {
    return data.fold((failure1) {
      return RequestEditErrorState(failure1, type);
    }, (data) {
      return RequestEditSuccessState(data);
    });
  }

  void signOut() {
    signOutUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateSignOut(value));
    });
  }

  RequestState eitherLoadedOrErrorStateSignOut(Either<String, String?> data) {
    return data.fold((failure1) {
      return SignOutErrorState(failure1);
    }, (data) {
      return SignOutSuccessState(data);
    });
  }
}
