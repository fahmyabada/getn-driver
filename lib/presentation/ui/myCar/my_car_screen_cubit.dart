import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/myCar/Data.dart';
import 'package:getn_driver/domain/usecase/myCar/CarEditUseCase.dart';
import 'package:getn_driver/domain/usecase/myCar/GetMyCarModelUseCase.dart';
import 'package:getn_driver/domain/usecase/myCar/GetMyCarSubCategoryUseCase.dart';
import 'package:getn_driver/domain/usecase/myCar/GetMyCarUseCase.dart';
import 'package:getn_driver/domain/usecase/myCar/GetMyColorUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'my_car_screen_state.dart';

class MyCarScreenCubit extends Cubit<MyCarScreenState> {
  MyCarScreenCubit() : super(MyCarScreenInitial());

  static MyCarScreenCubit get(context) => BlocProvider.of(context);

  var getMySubCarCategoryUseCase = getIt<GetMyCarSubCategoryUseCase>();
  var getMyCarModelUseCase = getIt<GetMyCarModelUseCase>();
  var getMyColorUseCase = getIt<GetMyColorUseCase>();
  var getMyCarUseCase = getIt<GetMyCarUseCase>();
  var carEditUseCase = getIt<CarEditUseCase>();

  List<category.Data> colors = [];
  List<category.Data> carModel = [];
  List<category.Data> carSubCategory = [];
  Data? car;
  bool carSuccess = false;
  bool carError = false;
  String carFailure = "";
  bool carModelLoading = false;
  bool carSubCategoryLoading = false;
  bool colorsLoading = false;

  void getCar() async {
    emit(CarLoading());
    getMyCarUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCar(value));
    });
  }

  MyCarScreenState eitherLoadedOrErrorStateCar(Either<String, Data?> data) {
    return data.fold((failure1) {
      carError = true;
      carFailure = failure1;
      return CarErrorState(failure1);
    }, (data) {
      car = data!;
      carSuccess = true;
      return CarSuccessState(data);
    });
  }

  void getCarModel() async {
    carModelLoading = true;
    getMyCarModelUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCarModel(value));
    });
  }

  MyCarScreenState eitherLoadedOrErrorStateCarModel(
      Either<String, List<category.Data>?> data) {
    return data.fold((failure1) {
      carModelLoading = false;
      return CarModelErrorState(failure1);
    }, (data) {
      carModelLoading = false;
      carModel = data!;
      return CarModelSuccessState(data);
    });
  }

  void getCarSubCategory() async {
    carSubCategoryLoading = true;
    getMySubCarCategoryUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCarCategory(value));
    });
  }

  MyCarScreenState eitherLoadedOrErrorStateCarCategory(
      Either<String, List<category.Data>?> data) {
    return data.fold((failure1) {
      carSubCategoryLoading = false;
      return CarSubCategoryErrorState(failure1);
    }, (data) {
      carSubCategoryLoading = false;
      carSubCategory = data!;
      return CarSubCategorySuccessState(data);
    });
  }

  void getColor() async {
    colorsLoading = true;
    getMyColorUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateColor(value));
    });
  }

  MyCarScreenState eitherLoadedOrErrorStateColor(
      Either<String, List<category.Data>?> data) {
    return data.fold((failure1) {
      colorsLoading = false;
      return ColorErrorState(failure1);
    }, (data) {
      colorsLoading = false;
      colors = data!;
      return ColorSuccessState(data);
    });
  }

  void carEdit(FormData data, String id) async {
    emit(CarEditLoading());
    carEditUseCase.execute(data, id).then((value) {
      emit(eitherLoadedOrErrorStateCarCreate(value));
    });
  }

  MyCarScreenState eitherLoadedOrErrorStateCarCreate(
      Either<String, CarRegisterationModel?> data) {
    return data.fold((failure1) {
      return CarEditErrorState(failure1);
    }, (data) {
      return CarEditSuccessState(data);
    });
  }
}
