import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/domain/usecase/infoBranch/GetBranchesInfoBranchUseCase.dart';
import 'package:getn_driver/domain/usecase/infoBranch/InfoPlaceBranchUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'info_branch_state.dart';

class InfoBranchCubit extends Cubit<InfoBranchState> {
  InfoBranchCubit() : super(InfoBranchInitial());

  static InfoBranchCubit get(context) => BlocProvider.of(context);

  var getBranchesInfoBranchUseCase = getIt<GetBranchesInfoBranchUseCase>();
  var infoPlaceBranchUseCase = getIt<InfoPlaceBranchUseCase>();

  Data? info;
  List<Data> branches = [];
  int indexBranches = 1;
  bool loadingBranches = false;

  void getBranches(int index, String placeId) async {
    var body = {"page": index, "place": placeId};
    if (index > 1) {
      getBranchesInfoBranchUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStatePlaces2(value));
      });
    } else {
      emit(GetBranchesInitial());
      getBranchesInfoBranchUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStatePlaces(value));
      });
    }
  }

  InfoBranchState eitherLoadedOrErrorStatePlaces(
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

  InfoBranchState eitherLoadedOrErrorStatePlaces2(
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

  void getInfoPlace(String id) async {
    emit(GetInfoPlaceInitial());
    infoPlaceBranchUseCase.execute(id).then((value) {
      emit(eitherLoadedOrErrorStateInfoPlace(value));
    });
  }

  InfoBranchState eitherLoadedOrErrorStateInfoPlace(
      Either<String, Data?> data) {
    return data.fold((failure1) {
      return GetInfoPlaceErrorState(failure1);
    }, (data) {
      info = data;
      print("getInfoPlaceGetInfoSuccessState******************$data");
      return GetInfoPlaceSuccessState(data);
    });
  }

}
