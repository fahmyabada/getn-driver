import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/data/model/api_result_model.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetCurrentLocationTripUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetTripDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/PutTripDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/SetPolyLinesUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit() : super(TripDetailsInitial());

  static TripDetailsCubit get(context) => BlocProvider.of(context);

  var getTripDetailsUseCase = getIt<GetTripDetailsUseCase>();
  var putTripDetailsUseCase = getIt<PutTripDetailsUseCase>();
  var updateAllDataUseCase = getIt<SetPolyLinesUseCase>();
  var getCurrentLocationTripUseCase = getIt<GetCurrentLocationTripUseCase>();
  APIResultModel? routeCoordinates;
  Data? tripDetails;

  void getTripDetails(String id) async {
    emit(TripDetailsLoading());
    getTripDetailsUseCase.execute(id).then((value) {
      emit(eitherLoadedOrErrorStateTripDetails(value, id));
    });
  }

  TripDetailsState eitherLoadedOrErrorStateTripDetails(
      Either<String, Data?> data, String id) {
    return data.fold((failure1) {
      return TripDetailsErrorState(failure1);
    }, (data) {
      tripDetails = data;
      return TripDetailsSuccessState(data);
    });
  }

  void editTrip(String id, String type, String comment,
      String latitude, String longitude, String place, String branch, String verifyCode) async {
    if (type != "reject" && type != "end") {
      emit(TripDetailsEditInitial());
    }

    putTripDetailsUseCase
        .execute(id, type, comment,  latitude, longitude, place, branch, verifyCode)
        .then((value) {
      emit(eitherLoadedOrErrorStateTripEdit(value, type));
    });
  }

  TripDetailsState eitherLoadedOrErrorStateTripEdit(
      Either<String, DataRequest?> data, String type) {
    return data.fold((failure1) {
      return TripDetailsEditErrorState(failure1, type);
    }, (data) {
      return TripDetailsEditSuccessState(data, type);
    });
  }

  Future<APIResultModel> getRouteCoordinates(LatLng l1, LatLng l2) {
    emit(GoogleMapInitial());
    return updateAllDataUseCase.execute(l1, l2).then((value) {
      return value.fold((failure) {
        GoogleMapErrorState(failure);
        return routeCoordinates =
            APIResultModel(message: failure, success: false, data: null);
      }, (data) {
        GoogleMapSuccessState(data);
        return routeCoordinates = data;
      });
    });
  }

  void getCurrentLocation() async {
    emit(CurrentLocationTripLoading());
    final data = await getCurrentLocationTripUseCase.execute();
    emit(eitherLoadedOrErrorStateCurrentLocation(data));
  }

  TripDetailsState eitherLoadedOrErrorStateCurrentLocation(
      Either<String, Position> data) {
    return data.fold((failure) {
      return CurrentLocationTripErrorState(failure);
    }, (data) {
      return CurrentLocationTripSuccessState(data);
    });
  }
}
