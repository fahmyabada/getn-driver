import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/placeDetails/Location.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/Predictions.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/usecase/addTrip/CreateTripUseCase.dart';
import 'package:getn_driver/domain/usecase/addTrip/GetPlaceDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/addTrip/GetSearchLocationUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'add_trip_state.dart';

class AddTripCubit extends Cubit<AddTripState> {
  AddTripCubit() : super(AddTripInitial());

  static AddTripCubit get(context) => BlocProvider.of(context);

  var getSearchLocationUseCase = getIt<GetSearchLocationUseCase>();
  var getPlaceDetailsUseCase = getIt<GetPlaceDetailsUseCase>();
  var createTripUseCase = getIt<CreateTripUseCase>();

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

  AddTripState eitherLoadedOrErrorStatePlaceDetails(
      Either<String, PlaceDetails?> data) {
    return data.fold((failure1) {
      return SetPlaceDetailsErrorState(failure1);
    }, (data) {
      return SetPlaceDetailsSuccessState(data?.result?.geometry?.location!);
    });
  }

  void createTrip(Data data) async {
    emit(CreateTripInitial());
    createTripUseCase.execute(data).then((value) {
      emit(eitherLoadedOrErrorStateCreateTrip(value));
    });
  }

  AddTripState eitherLoadedOrErrorStateCreateTrip(
      Either<String, Data?> data) {
    return data.fold((failure1) {
      return CreateTripErrorState(failure1);
    }, (data) {
      return CreateTripSuccessState(data);
    });
  }
}
