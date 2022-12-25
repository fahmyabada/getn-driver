import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/CategoryPlaceTrip.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/Data.dart';
import 'package:getn_driver/domain/usecase/categoryPlaceTripUseCase/GetCategoryPlaceTripUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'category_place_trip_screen_state.dart';

class CategoryPlaceTripScreenCubit extends Cubit<CategoryPlaceTripScreenState> {
  CategoryPlaceTripScreenCubit() : super(CategoryPlaceTripScreenInitial());

  static CategoryPlaceTripScreenCubit get(context) => BlocProvider.of(context);

  var getCategoryPlaceTripUseCase = getIt<GetCategoryPlaceTripUseCase>();
  bool loadingCategoryPlace = false;
  List<Data> categoryPlace = [];
  int indexCategoryPlace = 1;

  void getCategoryPlace(int index) async {
    if (index > 1) {
      getCategoryPlaceTripUseCase.execute(index).then((value) {
        emit(eitherLoadedOrErrorStateCategoryPlace2(value));
      });
    } else {
      loadingCategoryPlace = true;
      emit(CategoryPlaceTripInitial());
      getCategoryPlaceTripUseCase.execute(index).then((value) {
        loadingCategoryPlace = false;
        emit(eitherLoadedOrErrorStateCategoryPlace(value));
      });
    }
  }

  CategoryPlaceTripScreenState eitherLoadedOrErrorStateCategoryPlace(
      Either<String, CategoryPlaceTrip?> data) {
    return data.fold((failure1) {
      return CategoryPlaceTripErrorState(failure1);
    }, (data) {
      categoryPlace.clear();
      categoryPlace.addAll(data!.data!);
      indexCategoryPlace = indexCategoryPlace + 1;
      return CategoryPlaceTripSuccessState(data.data);
    });
  }

  CategoryPlaceTripScreenState eitherLoadedOrErrorStateCategoryPlace2(
      Either<String, CategoryPlaceTrip?> data) {
    return data.fold((failure1) {
      return CategoryPlaceTripErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > categoryPlace.length) {
        categoryPlace.addAll(data.data!);
        indexCategoryPlace = indexCategoryPlace + 1;
      }
      return CategoryPlaceTripSuccessState(data.data);
    });
  }
}
