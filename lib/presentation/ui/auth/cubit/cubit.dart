import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/usecase/auth/CarCreateUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/EditInformationUserUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetAreaAuthUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCarCategoryUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCarModelUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCitiesAuthUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetColorUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetRoleUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/LoginUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/RegisterUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/SendOtpUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(SignInitial());

  static SignCubit get(context) => BlocProvider.of(context);

  var getRoleUseCase = getIt<GetRoleUseCase>();
  var getCountriesUseCase = getIt<GetCountriesUseCase>();
  var getSubCarCategoryUseCase = getIt<GetCarSubCategoryUseCase>();
  var getCarModelUseCase = getIt<GetCarModelUseCase>();
  var getColorUseCase = getIt<GetColorUseCase>();
  var sendOtpUseCase = getIt<SendOtpUseCase>();
  var registerUseCase = getIt<RegisterUseCase>();
  var loginUseCase = getIt<LoginUseCase>();
  var editInformationUserUseCase = getIt<EditInformationUserUseCase>();
  var carCreateUseCase = getIt<CarCreateUseCase>();
  var getAreaAuthUseCase = getIt<GetAreaAuthUseCase>();
  var getCitiesAuthUseCase = getIt<GetCitiesAuthUseCase>();

  List<Country> countries = [];
  List<Country> city = [];
  List<Country> area = [];
  List<category.Data> colors = [];
  List<category.Data> carModel = [];
  List<category.Data> carSubCategory = [];
  List<DataRole> roles = [];
  bool carModelLoading = false;
  bool carSubCategoryLoading = false;
  bool colorsLoading = false;
  bool loadingCity = false;
  bool loadingArea = false;
  String failureCity = "";
  String failureArea = "";

  void getCountries() async {
    emit(CountriesLoading());
    getCountriesUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCountries(value));
    });
  }

  SignState eitherLoadedOrErrorStateCountries(
      Either<String, List<Country>?> data) {
    return data.fold((failure1) {
      countries.clear();
      return CountriesErrorState(failure1);
    }, (data) {
      countries = data!;
      return CountriesSuccessState(data);
    });
  }

  void getCity(String countryId) async {
    loadingCity = true;
    emit(CityLoading());
    getCitiesAuthUseCase.execute(countryId).then((value) {
      emit(eitherLoadedOrErrorStateCity(value));
    });
  }

  SignState eitherLoadedOrErrorStateCity(Either<String, List<Country>?> data) {
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
    getAreaAuthUseCase.execute(countryId, cityId).then((value) {
      emit(eitherLoadedOrErrorStateArea(value));
    });
  }

  SignState eitherLoadedOrErrorStateArea(Either<String, List<Country>?> data) {
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

  void getCarModel() async {
    carModelLoading = true;
    getCarModelUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCarModel(value));
    });
  }

  SignState eitherLoadedOrErrorStateCarModel(
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
    getSubCarCategoryUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCarCategory(value));
    });
  }

  SignState eitherLoadedOrErrorStateCarCategory(
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
    getColorUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateColor(value));
    });
  }

  SignState eitherLoadedOrErrorStateColor(
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

  void getRole() async {
    emit(RoleLoading());
    getRoleUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateRole(value));
    });
  }

  SignState eitherLoadedOrErrorStateRole(Either<String, List<DataRole>?> data) {
    return data.fold((failure1) {
      return RoleErrorState(failure1);
    }, (data) {
      roles = data!;
      return RoleSuccessState(data);
    });
  }

  void sendOtp(String type, String phone, String countryId) async {
    sendOtpUseCase.execute(type, phone, countryId).then((value) {
      emit(eitherLoadedOrErrorStateSendOtp(type, value));
    });
  }

  SignState eitherLoadedOrErrorStateSendOtp(
      String type, Either<String, SendOtpData> data) {
    return data.fold((failure1) {
      if (type == "login") {
        return SendOtpSignInErrorState(failure1);
      } else if (type == "register") {
        return SendOtpSignUpErrorState(failure1);
      } else {
        return SendOtpErrorState(failure1);
      }
    }, (data) {
      if (type == "login") {
        return SendOtpSignInSuccessState(data);
      } else if (type == "register") {
        return SendOtpSignUpSuccessState(data);
      } else {
        return SendOtpSuccessState(data);
      }
    });
  }

  void makeRegister(
      String phone,
      String countryId,
      String email,
      String firebaseToken,
      String fullName,
      String role,
      bool terms,
      String photo,
      String birthDate,
      String cityId,
      String areaId,
      String addressId,
      String availabilities,
      String userImage) async {
    String verifyImageName = photo.split('/').last;
    String userImageName = userImage.split('/').last;

    var formData = FormData.fromMap({
      'phone': phone,
      'name': fullName,
      'email': email,
      'birthDate': birthDate,
      'country': countryId,
      'city': cityId,
      'area': areaId,
      'role': role,
      'fcmToken': getIt<SharedPreferences>().getString("fcmToken"),
      'image': await MultipartFile.fromFile(userImage,
          filename: userImageName, contentType: MediaType("image", "jpeg")),
      'verifyImage': await MultipartFile.fromFile(photo,
          filename: verifyImageName, contentType: MediaType("image", "jpeg")),
      'acceptTermsAndConditions': terms,
    });
    emit(RegisterLoading());
    registerUseCase.execute(formData, firebaseToken).then((value) {
      emit(eitherLoadedOrErrorStateMakeRegister(value));
    });
  }

  SignState eitherLoadedOrErrorStateMakeRegister(
      Either<String, SignModel> data) {
    return data.fold((failure1) {
      return RegisterErrorState(failure1);
    }, (data) {
      return RegisterSuccessState(data);
    });
  }

  void makeLogin(String phone, String countryId, String firebaseToken) async {
    emit(SignInLoading());
    loginUseCase.execute(phone, countryId, firebaseToken).then((value) {
      emit(eitherLoadedOrErrorStateMakeLogin(value));
    });
  }

  SignState eitherLoadedOrErrorStateMakeLogin(Either<String, SignModel> data) {
    return data.fold((failure1) {
      return SignInErrorState(failure1);
    }, (data) {
      return SignInSuccessState(data);
    });
  }

  void editInformation(String frontNationalId, String backNationalId,
      String frontDriverLicence, String backDriverLicence) async {
    emit(EditLoading());
    String fileFrontNationalId = frontNationalId.split('/').last;
    String fileBackNationalId = backNationalId.split('/').last;
    String fileFrontDriverLicenced = frontDriverLicence.split('/').last;
    String fileBackDriverLicence = backDriverLicence.split('/').last;
    var formData = FormData.fromMap({
      'frontNationalImage': await MultipartFile.fromFile(frontNationalId,
          filename: fileFrontNationalId,
          contentType: MediaType("image", "jpeg")),
      'backNationalImage': await MultipartFile.fromFile(backNationalId,
          filename: fileBackNationalId,
          contentType: MediaType("image", "jpeg")),
      'frontDriveImage': await MultipartFile.fromFile(frontDriverLicence,
          filename: fileFrontDriverLicenced,
          contentType: MediaType("image", "jpeg")),
      'backDriveImage': await MultipartFile.fromFile(backDriverLicence,
          filename: fileBackDriverLicence,
          contentType: MediaType("image", "jpeg")),
    });
    editInformationUserUseCase.execute(formData).then((value) {
      emit(eitherLoadedOrErrorStateEditInformation(value));
    });
  }

  SignState eitherLoadedOrErrorStateEditInformation(
      Either<String, SignModel> data) {
    return data.fold((failure1) {
      return EditErrorState(failure1);
    }, (data) {
      return EditSuccessState(data);
    });
  }

  void carCreate(FormData data) async {
    emit(CarCreateLoading());
    carCreateUseCase.execute(data).then((value) {
      emit(eitherLoadedOrErrorStateCarCreate(value));
    });
  }

  SignState eitherLoadedOrErrorStateCarCreate(
      Either<String, CarRegisterationModel?> data) {
    return data.fold((failure1) {
      return CarCreateErrorState(failure1);
    }, (data) {
      return CarCreateSuccessState(data);
    });
  }
}
