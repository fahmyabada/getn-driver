import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/usecase/auth/CarCreateUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/EditInformationUserUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCarCategoryUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCarModelUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetColorUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/LoginUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/GetRoleUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/RegisterUseCase.dart';
import 'package:getn_driver/domain/usecase/auth/SendOtpUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:http_parser/http_parser.dart';

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

  List<Data> countries = [];
  List<category.Data> colors = [];
  List<category.Data> carModel = [];
  List<category.Data> carSubCategory = [];
  List<DataRole> roles = [];
  bool carModelLoading = false;
  bool carSubCategoryLoading = false;
  bool colorsLoading = false;
  bool terms = false;
  bool frontNationalId = false;
  bool backNationalId = false;

  // bool frontPassport = false;
  // bool backPassport = false;
  bool frontDriverLicence = false;
  bool backDriverLicence = false;
  String? frontNationalIdString;
  String? backNationalIdString;

  // String? frontPassportString;
  // String? backPassportString;
  String? frontDriverLicenceString;
  String? backDriverLicenceString;

  void getCountries() async {
    emit(CountriesLoading());
    getCountriesUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCountries(value));
    });
  }

  SignState eitherLoadedOrErrorStateCountries(
      Either<String, List<Data>?> data) {
    return data.fold((failure1) {
      return CountriesErrorState(failure1);
    }, (data) {
      countries = data!;
      return CountriesSuccessState(data);
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
    emit(SendOtpLoading());
    sendOtpUseCase.execute(type, phone, countryId).then((value) {
      emit(eitherLoadedOrErrorStateSendOtp(type, value));
    });
  }

  SignState eitherLoadedOrErrorStateSendOtp(String type,
      Either<String, SendOtpData> data) {
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

  void makeRegister(String phone,
      String countryId,
      String email,
      String firebaseToken,
      String fullName,
      String role,
      bool terms,
      String photo) async {
    emit(RegisterLoading());
    registerUseCase
        .execute(
        phone,
        countryId,
        email,
        firebaseToken,
        fullName,
        role,
        terms,
        photo)
        .then((value) {
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
    String fileFrontNationalId = frontNationalId
        .split('/')
        .last;
    String fileBackNationalId = backNationalId
        .split('/')
        .last;
    String fileFrontDriverLicenced = frontDriverLicence
        .split('/')
        .last;
    String fileBackDriverLicence = backDriverLicence
        .split('/')
        .last;
    var formData = FormData.fromMap({
    'frontNationalImage': await MultipartFile.fromFile(frontNationalId, filename: fileFrontNationalId, contentType: MediaType("image", "jpeg")),
    'backNationalImage': await MultipartFile.fromFile(backNationalId, filename: fileBackNationalId, contentType: MediaType("image", "jpeg")),
    'frontDriveImage': await MultipartFile.fromFile(frontDriverLicence, filename: fileFrontDriverLicenced, contentType: MediaType("image", "jpeg")),
    'backDriveImage': await MultipartFile.fromFile(backDriverLicence, filename: fileBackDriverLicence, contentType: MediaType("image", "jpeg")),
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

  void setTerms(bool data) {
    terms = data;

    emit(TermsSuccessState());
  }

  void setChangeUpdateBool(String type, bool data) {
    if (type == "frontNationalId") {
      frontNationalId = data;
    } else if (type == "backNationalId") {
      backNationalId = data;
    }
    // else if (type == "frontPassport") {
    //   frontPassport = data;
    // } else if (type == "backPassport") {
    //   backPassport = data;
    // }
    else if (type == "frontDriverLicence") {
      frontDriverLicence = data;
    } else if (type == "backDriverLicence") {
      backDriverLicence = data;
    }

    emit(DriverInformationLoading());
  }


  void carCreate(FormData data) async {
    emit(CarCreateLoading());
    carCreateUseCase.execute(data).then((value) {
      emit(eitherLoadedOrErrorStateCarCreate(value));
    });
  }

  SignState eitherLoadedOrErrorStateCarCreate(Either<String, List<category.Data>?> data) {
    return data.fold((failure1) {
      return CarCreateErrorState(failure1);
    }, (data) {
      return CarCreateSuccessState(data);
    });
  }
}
