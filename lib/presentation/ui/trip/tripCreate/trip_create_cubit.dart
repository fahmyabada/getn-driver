import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/CanCreateTrip/CanCreateTrip.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/data/model/placeDetails/Location.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/Predictions.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/usecase/tripCreate/CanCreateTripUseCase.dart';
import 'package:getn_driver/domain/usecase/tripCreate/CreateTripUseCase.dart';
import 'package:getn_driver/domain/usecase/tripCreate/GetPlaceDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripCreate/GetSearchLocationUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'trip_create_state.dart';

class TripCreateCubit extends Cubit<TripCreateState> {
  TripCreateCubit() : super(AddTripInitial());

  static TripCreateCubit get(context) => BlocProvider.of(context);

  var getSearchLocationUseCase = getIt<GetSearchLocationUseCase>();
  var getPlaceDetailsUseCase = getIt<GetPlaceDetailsUseCase>();
  var createTripUseCase = getIt<CreateTripUseCase>();
  var canCreateTripUseCase = getIt<CanCreateTripUseCase>();

  List<Predictions>? listPredictions = [];

  Future<List<Predictions>> searchLocation(String text) async {
    return getSearchLocationUseCase.execute(text).then((value) {
      return value.fold((failure1) {
        emit(SearchLocationErrorState(failure1));
        return [];
      }, (data) {
        return data!.predictions!;
      });
    });
  }

  void getPlaceDetails(String placeId) async {
    getPlaceDetailsUseCase.execute(placeId).then((value) {
      emit(eitherLoadedOrErrorStatePlaceDetails(value));
    });
  }

  TripCreateState eitherLoadedOrErrorStatePlaceDetails(
      Either<String, PlaceDetails?> data) {
    return data.fold((failure1) {
      return SetPlaceDetailsErrorState(failure1);
    }, (data) {
      return SetPlaceDetailsSuccessState(data?.result?.geometry?.location!);
    });
  }

  void createTrip(CreateTripModel data) async {
    createTripUseCase.execute(data).then((value) {
      emit(eitherLoadedOrErrorStateCreateTrip(value));
    });
  }

  TripCreateState eitherLoadedOrErrorStateCreateTrip(
      Either<String, Data?> data) {
    return data.fold((failure1) {
      return CreateTripErrorState(failure1);
    }, (data) {
      return CreateTripSuccessState(data);
    });
  }

  void canCreateTrip(CreateTripModel data) async {
    emit(CreateTripInitial());
    canCreateTripUseCase.execute(data).then((value) {
      emit(eitherLoadedOrErrorStateCanCreateTrip(value));
    });
  }

  TripCreateState eitherLoadedOrErrorStateCanCreateTrip(
      Either<String, CanCreateTrip?> data) {
    return data.fold((failure1) {
      return CanCreateTripErrorState(failure1);
    }, (data) {
      return CanCreateTripSuccessState(data);
    });
  }
}
