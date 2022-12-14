import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetCurrentLocationUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetLastTripUseCase.dart';
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
  var getLastTripsUseCase = getIt<GetLastTripsUseCase>();

  DataRequest? requestDetails;
  List<Data> trips = [];
  int indexTrips = 1;
  bool loadingTrips = false;
  bool loadingRequest = false;
  bool? tripsSuccess;
  String failureRequest = "";
  String failureTrip = "";
  String typeScreen = "";
  String idRequest = '';

  void getRequestDetails(String id) async {
    idRequest = id;
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
      tripsSuccess = false;
      print("TripsErrorState*********** $failure1");
      return TripsErrorState(failure1);
    }, (data) {
      if (kDebugMode) {
        print("TripsSuccessState*********** ${data!.data!}");
      }
      trips.clear();
      trips.addAll(data!.data!);
      indexTrips = 2;
      loadingTrips = false;
      tripsSuccess = true;
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
      tripsSuccess = true;
      return TripsSuccessState(data);
    });
  }

  void editRequest(String id, String type, String comment) async {
    if (type != "reject" && type != "mid_pause" && type != "end") {
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

  void getLastTrip(String idRequest, String type) async {
    if (type == 'end') {
      emit(RequestDetailsEditInitial());
    } else if (type == 'mid_pause' || type == 'reject') {
      emit(RequestDetailsEditCancelInitial());
    }
    getLastTripsUseCase.execute(idRequest).then((value) {
      emit(eitherLoadedOrErrorStateLastTrip(value, type));
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateLastTrip(
      Either<String, Request?> data, String type) {
    return data.fold((failure1) {
      print("RequestDetailsLastTripErrorState*********** $failure1");
      return RequestDetailsLastTripErrorState(failure1);
    }, (data) {
      print("RequestDetailsLastTripSuccessState*********** ${type}");
      return RequestDetailsLastTripSuccessState(data, type);
    });
  }

  void getCurrentLocation(String type) async {
    loadingRequest = true;
    emit(CurrentLocationLoading());
    final data = await getCurrentLocationUseCase.execute();
    emit(eitherLoadedOrErrorStateCurrentLocation(data, type));
  }

  RequestDetailsState eitherLoadedOrErrorStateCurrentLocation(
      Either<String, Position> data, String type) {
    return data.fold((failure) {
      loadingRequest = false;
      return CurrentLocationErrorState(failure);
    }, (data) {
      loadingRequest = false;
      return CurrentLocationSuccessState(data,type);
    });
  }
}
