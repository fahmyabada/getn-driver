import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/packages/PackagesModel.dart';
import 'package:getn_driver/domain/usecase/packages/GetPackagesUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

import '../../../data/model/packages/Data.dart';

part 'packages_screen_state.dart';

class PackagesScreenCubit extends Cubit<PackagesScreenState> {
  PackagesScreenCubit() : super(PackagesScreenInitial());

  static PackagesScreenCubit get(context) => BlocProvider.of(context);

  var getPackagesUseCase = getIt<GetPackagesUseCase>();

  List<Data> packages = [];
  int indexPackages = 1;

  void getNotification(int index, String carCategory) async {
    if (index > 1) {
      getPackagesUseCase.execute(index, carCategory).then((value) {
        emit(eitherLoadedOrErrorStateNotification2(value));
      });
    } else {
      emit(PackagesLoading());
      getPackagesUseCase.execute(index, carCategory).then((value) {
        emit(eitherLoadedOrErrorStateNotification(value));
      });
    }
  }

  PackagesScreenState eitherLoadedOrErrorStateNotification(
      Either<String, PackagesModel?> data) {
    return data.fold((failure1) {
      return PackagesErrorState(failure1);
    }, (data) {
      packages.clear();
      packages.addAll(data!.data!);
      indexPackages = indexPackages + 1;

      return PackagesSuccessState(data);
    });
  }

  PackagesScreenState eitherLoadedOrErrorStateNotification2(
      Either<String, PackagesModel?> data) {
    return data.fold((failure1) {
      return PackagesErrorState(failure1);
    }, (data) {
      if (data!.totalCount! > packages.length) {
        packages.addAll(data.data!);
        indexPackages = indexPackages + 1;
      }

      return PackagesSuccessState(data);
    });
  }
}
