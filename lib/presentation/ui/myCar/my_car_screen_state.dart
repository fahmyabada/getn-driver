part of 'my_car_screen_cubit.dart';

@immutable
abstract class MyCarScreenState {}

class MyCarScreenInitial extends MyCarScreenState {}

class CarLoading extends MyCarScreenState {}

class CarErrorState extends MyCarScreenState {
  final String message;

  CarErrorState(this.message);
}

class CarSuccessState extends MyCarScreenState {
  final Data? data;

  CarSuccessState(this.data);
}


class CarModelErrorState extends MyCarScreenState {
  final String message;

  CarModelErrorState(this.message);
}

class CarModelSuccessState extends MyCarScreenState {
  final List<category.Data>? data;

  CarModelSuccessState(this.data);
}

class CarSubCategoryErrorState extends MyCarScreenState {
  final String message;

  CarSubCategoryErrorState(this.message);
}

class CarSubCategorySuccessState extends MyCarScreenState {
  final List<category.Data>? data;

  CarSubCategorySuccessState(this.data);
}

class ColorErrorState extends MyCarScreenState {
  final String message;

  ColorErrorState(this.message);
}

class ColorSuccessState extends MyCarScreenState {
  final List<category.Data>? data;

  ColorSuccessState(this.data);
}

class CarEditLoading extends MyCarScreenState {}

class CarEditErrorState extends MyCarScreenState {
  final String message;

  CarEditErrorState(this.message);
}

class CarEditSuccessState extends MyCarScreenState {
  final CarRegisterationModel? data;

  CarEditSuccessState(this.data);
}