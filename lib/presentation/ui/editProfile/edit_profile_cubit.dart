import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetAreaEditProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetCitiesEditProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetCountriesEditProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetProfileDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  var getProfileDetailsUseCase = getIt<GetProfileDetailsUseCase>();
  var getAreaEditProfileUseCase = getIt<GetAreaEditProfileUseCase>();
  var getCitiesEditProfileUseCase = getIt<GetCitiesEditProfileUseCase>();
  var getCountriesEditProfileUseCase = getIt<GetCountriesEditProfileUseCase>();

  EditProfileModel? profileDetails;
  List<Data> countries = [];
  List<Data> city = [];
  List<Data> area = [];

  void getProfileDetails() async {
    emit(EditProfileLoading());
    getProfileDetailsUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateProfileDetails(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateProfileDetails(
      Either<String, EditProfileModel?> data) {
    return data.fold((failure1) {
      print("EditProfileErrorState*********** $failure1");
      return EditProfileErrorState(failure1);
    }, (data) {
      print("EditProfileSuccessState*********** $data");
      profileDetails = data;

      return EditProfileSuccessState(data);
    });
  }

  void getCountries() async {
    emit(CountriesLoading());
    getCountriesEditProfileUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCountries(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateCountries(
      Either<String, List<Data>?> data) {
    return data.fold((failure1) {
      return CountriesErrorState(failure1);
    }, (data) {
      countries = data!;
      return CountriesSuccessState(data);
    });
  }

  void getCity(String countryId) async {
    emit(CityLoading());
    getCitiesEditProfileUseCase.execute(countryId).then((value) {
      emit(eitherLoadedOrErrorStateCity(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateCity(
      Either<String, List<Data>?> data) {
    return data.fold((failure1) {
      print("CityErrorState*********** $failure1");
      return CityErrorState(failure1);
    }, (data) {
      print("CitySuccessState*********** $data");
      city = data!;

      return CitySuccessState(data);
    });
  }

  void getArea(String countryId, String cityId) async {
    emit(AreaLoading());
    getAreaEditProfileUseCase.execute(countryId, cityId).then((value) {
      emit(eitherLoadedOrErrorStateArea(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateArea(
      Either<String, List<Data>?> data) {
    return data.fold((failure1) {
      print("AreaErrorState*********** $failure1");
      return AreaErrorState(failure1);
    }, (data) {
      print("AreaSuccessState*********** $data");
      area = data!;

      return AreaSuccessState(data);
    });
  }
}
