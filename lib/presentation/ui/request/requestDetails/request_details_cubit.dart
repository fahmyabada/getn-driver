import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetCurrentLocationUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetTripsRequestDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'request_details_state.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  RequestDetailsCubit() : super(RequestDetailsInitial());

  static RequestDetailsCubit get(context) => BlocProvider.of(context);

  var getRequestDetailsUseCase = getIt<GetRequestDetailsUseCase>();
  var getTripsRequestDetailsUseCase = getIt<GetTripsRequestDetailsUseCase>();
  var putRequestUseCase = getIt<PutRequestUseCase>();
  var getCurrentLocationUseCase = getIt<GetCurrentLocationUseCase>();

  DataRequest? requestDetails;
  List<Data> trips = [];
  int indexTrips = 1;
  bool loadingTrips = false;
  bool loadingRequest = false;
  String failureRequest = "";
  String failureTrip = "";

  void getRequestDetails(String id) async {
    emit(RequestDetailsInitial());
    loadingRequest = true;
    getRequestDetailsUseCase.execute(id).then((value) {
      emit(eitherLoadedOrErrorStateRequestDetails(value, id));
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateRequestDetails(
      Either<String, DataRequest?> data, String id) {
    return data.fold((failure1) {
      loadingRequest = false;
      failureRequest = failure1;
      print("RequestDetailsErrorState*********** $failure1");
      return RequestDetailsErrorState(failure1);
    }, (data) {
      print("RequestDetailsSuccessState*********** ${data}");
      requestDetails = data;
      loadingRequest = false;

      return RequestDetailsSuccessState(data);
    });
  }

  void getTripsRequestDetails(int index, String id) async {
    var body = {
      "request": id,
      "page": index,
      "sort": "startDate:-1",
    };
    print("getTripsRequestDetails*********** $body");
    if (index > 1) {
      getTripsRequestDetailsUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateTripsRequestDetails2(value));
      });
    } else {
      loadingTrips = true;
      emit(TripsInitial());
      getTripsRequestDetailsUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateTripsRequestDetails(value));
      });
    }
  }

  RequestDetailsState eitherLoadedOrErrorStateTripsRequestDetails(
      Either<String, Trips?> data) {
    return data.fold((failure1) {
      failureTrip = failure1;
      loadingTrips = false;
      // trips.clear();
      print("TripsErrorState*********** $failure1");
      return TripsErrorState(failure1);
    }, (data) {
      if (kDebugMode) {
        print("TripsSuccessState*********** ${data!.data!}");
      }
      trips.clear();
      trips.addAll(data!.data!);
      indexTrips = indexTrips + 1;
      loadingTrips = false;
      return TripsSuccessState(data);
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateTripsRequestDetails2(
      Either<String, Trips?> data) {
    return data.fold((failure1) {
      return TripsErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > trips.length) {
        trips.addAll(data.data!);
        indexTrips = indexTrips + 1;
      }
      return TripsSuccessState(data);
    });
  }

  void editRequest(String id, String type, String comment) async {
    if (type == "reject" || type == "mid_pause") {
      emit(RequestDetailsEditRejectInitial());
    } else {
      emit(RequestDetailsEditInitial());
    }

    putRequestUseCase.execute(id, type, comment).then((value) {
      emit(eitherLoadedOrErrorStateRequestEdit(value, type));
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateRequestEdit(
      Either<String, DataRequest?> data, String type) {
    return data.fold((failure1) {
      return RequestDetailsEditErrorState(failure1, type);
    }, (data) {
      return RequestDetailsEditSuccessState(data, type);
    });
  }

  void getCurrentLocation() async {
    loadingRequest = true;
    emit(CurrentLocationLoading());
    final data = await getCurrentLocationUseCase.execute();
    emit(eitherLoadedOrErrorStateCurrentLocation(data));
  }

  RequestDetailsState eitherLoadedOrErrorStateCurrentLocation(
      Either<String, Position> data) {
    return data.fold((failure) {
      return CurrentLocationErrorState(failure);
    }, (data) {
      return CurrentLocationSuccessState(data);
    });
  }
}
