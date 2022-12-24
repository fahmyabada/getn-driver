import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/domain/usecase/branchesPlaces/GetBranchesPlacesUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'branches_places_state.dart';

class BranchesPlacesCubit extends Cubit<BranchesPlacesState> {
  BranchesPlacesCubit() : super(BranchesPlacesInitial());

  static BranchesPlacesCubit get(context) => BlocProvider.of(context);

  var getBranchesPlacesUseCase = getIt<GetBranchesPlacesUseCase>();
  List<Data> branches = [];
  int indexBranches = 1;
  bool loadingBranches = false;

  void getBranches(int index, String placeId) async {
    var body = {
      "page": index,
      "place": placeId,
      "select-country": "title",
      "select-city": "title",
      "select-area": "title"
    };
    if (index > 1) {
      getBranchesPlacesUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStatePlaces2(value));
      });
    } else {
      emit(GetBranchesInitial());
      getBranchesPlacesUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStatePlaces(value));
      });
    }
  }

  BranchesPlacesState eitherLoadedOrErrorStatePlaces(
      Either<String, RecomendPlaces?> data) {
    return data.fold((failure1) {
      return GetBranchesErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        branches.clear();
        branches = data.data!;
        indexBranches = indexBranches + 1;
        loadingBranches = true;
      }
      return GetBranchesSuccessState(data.data);
    });
  }

  BranchesPlacesState eitherLoadedOrErrorStatePlaces2(
      Either<String, RecomendPlaces?> data) {
    return data.fold((failure1) {
      return GetBranchesErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! > branches.length) {
          loadingBranches = true;
          branches.addAll(data.data!);
          indexBranches = indexBranches + 1;
        } else {
          loadingBranches = false;
        }
      }
      return GetBranchesSuccessState(data.data);
    });
  }
}
