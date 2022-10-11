import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/placeDetails/Location.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/Predictions.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetPlaceDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetSearchLocationUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/GetTripDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/tripDetails/PutTripDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'trip_details_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  TripDetailsCubit() : super(TripDetailsInitial());

  static TripDetailsCubit get(context) => BlocProvider.of(context);

  var getTripDetailsUseCase = getIt<GetTripDetailsUseCase>();
  var putTripDetailsUseCase = getIt<PutTripDetailsUseCase>();
  var getSearchLocationUseCase = getIt<GetSearchLocationUseCase>();
  var getPlaceDetailsUseCase = getIt<GetPlaceDetailsUseCase>();

  Data? tripDetails;
  List<Predictions>? listPredictions = [];
  Predictions? onSuggestionSelected;

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

  void editTrip(String id, String type) async {
    emit(TripDetailsEditInitial());

    putTripDetailsUseCase.execute(id, type).then((value) {
      emit(eitherLoadedOrErrorStateTripEdit(value));
    });
  }

  TripDetailsState eitherLoadedOrErrorStateTripEdit(
      Either<String, DataRequest?> data) {
    return data.fold((failure1) {
      return TripDetailsEditErrorState(failure1);
    }, (data) {
      return TripDetailsEditSuccessState(data);
    });
  }

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

  TripDetailsState eitherLoadedOrErrorStatePlaceDetails(
      Either<String, PlaceDetails?> data) {
    return data.fold((failure1) {
      return SetPlaceDetailsErrorState(failure1);
    }, (data) {
      return SetPlaceDetailsSuccessState(data?.result?.geometry?.location!);
    });
  }

  setSuggestionSelected(Predictions predictions){
    onSuggestionSelected = predictions;
    emit(SetSuggestionSelectedState(predictions));
  }
}
