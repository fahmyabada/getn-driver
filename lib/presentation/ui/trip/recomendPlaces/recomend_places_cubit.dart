import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/domain/usecase/recomendPlaces/GetRecomendPlacesUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'recomend_places_state.dart';

class RecomendPlacesCubit extends Cubit<RecomendPlacesState> {
  RecomendPlacesCubit() : super(RecomendPlacesInitial());

  static RecomendPlacesCubit get(context) => BlocProvider.of(context);

  var getRecomendPlacesUseCase = getIt<GetRecomendPlacesUseCase>();
  List<Data> places = [];
  int indexPlaces = 0;
  bool loadingPlaces = false;

  void getPlaces(int index) async {
    var body = {"page": index};
    if (index > 1) {
      getRecomendPlacesUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStatePlaces2(value));
      });
    } else {
      emit(GetPlacesInitial());
      getRecomendPlacesUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStatePlaces(value));
      });
    }
  }

  RecomendPlacesState eitherLoadedOrErrorStatePlaces(
      Either<String, RecomendPlaces?> data) {
    return data.fold((failure1) {
      return GetPlacesErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        places.clear();
        places = data.data!;
        indexPlaces = indexPlaces + 1;
        loadingPlaces = true;
      }
      return GetPlacesSuccessState(data.data);
    });
  }

  RecomendPlacesState eitherLoadedOrErrorStatePlaces2(
      Either<String, RecomendPlaces?> data) {
    return data.fold((failure1) {
      return GetPlacesErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= places.length) {
          loadingPlaces = true;
          places.addAll(data.data!);
          indexPlaces = indexPlaces + 1;
        } else {
          loadingPlaces = false;
        }
      }
      return GetPlacesSuccessState(data.data);
    });
  }
}
