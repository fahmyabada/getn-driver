import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/usecase/editProfile/EditProfileUserUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetAreaEditProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetCitiesEditProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetCountriesEditProfileUseCase.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetProfileDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  var getProfileDetailsUseCase = getIt<GetProfileDetailsUseCase>();
  var getAreaEditProfileUseCase = getIt<GetAreaEditProfileUseCase>();
  var getCitiesEditProfileUseCase = getIt<GetCitiesEditProfileUseCase>();
  var getCountriesEditProfileUseCase = getIt<GetCountriesEditProfileUseCase>();
  var editProfileUserUseCase = getIt<EditProfileUserUseCase>();

  EditProfileModel? profileDetails;
  List<Country> countries = [];
  List<Country> city = [];
  List<Country> area = [];
  String failure = "";
  String failureCountry = "";
  String failureCity = "";
  String failureArea = "";
  bool loadingCountry = false;
  bool loadingCity = false;
  bool loadingArea = false;
  bool loadingEdit = false;

  void getProfileDetails() async {
    emit(GetProfileDetailsLoading());
    getProfileDetailsUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateProfileDetails(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateProfileDetails(
      Either<String, EditProfileModel?> data) {
    return data.fold((failure1) {
      failure = failure1;
      return GetProfileDetailsErrorState(failure1);
    }, (data) {
      profileDetails = data;

      return GetProfileDetailsSuccessState(data);
    });
  }

  void getCountries() async {
    loadingCountry = true;
    emit(CountriesLoading());
    getCountriesEditProfileUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCountries(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateCountries(
      Either<String, List<Country>?> data) {
    return data.fold((failure1) {
      failureCountry = failure1;
      loadingCountry = false;
      return CountriesErrorState(failure1);
    }, (data) {
      countries = data!;
      loadingCountry = false;
      print("CountriesSuccessState*********** ${countries.toString()}");
      return CountriesSuccessState(data);
    });
  }

  void getCity(String countryId) async {
    loadingCity = true;
    emit(CityLoading());
    getCitiesEditProfileUseCase.execute(countryId).then((value) {
      emit(eitherLoadedOrErrorStateCity(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateCity(
      Either<String, List<Country>?> data) {
    return data.fold((failure1) {
      failureCity = failure1;
      loadingCity = false;
      print("CityErrorState*********** $failure1");
      return CityErrorState(failure1);
    }, (data) {
      print("CitySuccessState*********** $data");
      city = data!;
      loadingCity = false;
      return CitySuccessState(data);
    });
  }

  void getArea(String countryId, String cityId) async {
    loadingArea = true;
    emit(AreaLoading());
    getAreaEditProfileUseCase.execute(countryId, cityId).then((value) {
      emit(eitherLoadedOrErrorStateArea(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateArea(
      Either<String, List<Country>?> data) {
    return data.fold((failure1) {
      failureArea = failure1;
      loadingArea = false;
      print("AreaErrorState*********** $failure1");
      return AreaErrorState(failure1);
    }, (data) {
      print("AreaSuccessState*********** $data");
      area = data!;
      loadingArea = false;
      return AreaSuccessState(data);
    });
  }

  void editProfileDetails(
      String name,
      String email,
      String birthDate,
      String brief,
      String idCountries,
      String idCity,
      String idArea,
      String userImage,
      List<String> availabilities,
      // if take photo from device or from server
      bool imageRemote,
      String address,
      String whatsApp,
      bool lang,
      String whatsappCountry) async {
    loadingEdit = true;
    emit(EditProfileLoading());
    final body = jsonEncode(availabilities);
    String userImageName = userImage.split('/').last;
    FormData formData;
    if (imageRemote) {
      formData = FormData.fromMap({
        'name': name,
        'email': email,
        'birthDate': birthDate,
        'brief': brief,
        'country': idCountries,
        'city': idCity,
        'area': idArea,
        'availabilities': body,
        'address': address,
        'whatsapp': whatsApp,
        'whatsappCountry': whatsappCountry,
        'lang': lang ? "en" : "ar",
      });
    } else {
      formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(userImage,
            filename: userImageName, contentType: MediaType("image", "jpeg")),
        'name': name,
        'email': email,
        'birthDate': birthDate,
        'brief': brief,
        'country': idCountries,
        'city': idCity,
        'area': idArea,
        'availabilities': body,
        'address': address,
        'whatsapp': whatsApp,
        'whatsappCountry': whatsappCountry,
        'lang': lang ? "en" : "ar",
      });
    }
    editProfileUserUseCase.execute(formData).then((value) {
      emit(eitherLoadedOrErrorStateEditInformation(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateEditInformation(
      Either<String, EditProfileModel> data) {
    return data.fold((failure1) {
      loadingEdit = false;
      return EditProfileErrorState(failure1);
    }, (data) {
      loadingEdit = false;
      return EditProfileSuccessState(data);
    });
  }
}
