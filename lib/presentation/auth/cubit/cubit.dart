import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/usecase/signIn/EditInformationUserUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/GetRoleUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/LoginUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/SendOtpUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecase/signIn/RegisterUseCase.dart';
import 'package:http_parser/http_parser.dart';

part 'state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(SignInitial());

  static SignCubit get(context) => BlocProvider.of(context);

  var getRoleUseCase = getIt<GetRoleUseCase>();
  var getCountriesUseCase = getIt<GetCountriesUseCase>();
  var sendOtpUseCase = getIt<SendOtpUseCase>();
  var registerUseCase = getIt<RegisterUseCase>();
  var loginUseCase = getIt<LoginUseCase>();
  var editInformationUserUseCase = getIt<EditInformationUserUseCase>();

  List<Data> countries = [];
  List<DataRole> roles = [];
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
    sendOtpUseCase.execute(phone, countryId).then((value) {
      emit(eitherLoadedOrErrorStateSendOtp(type, value));
    });
  }

  SignState eitherLoadedOrErrorStateSendOtp(String type,
      Either<String, SendOtpData> data) {
    return data.fold((failure1) {
      if (type == "signIn") {
        return SendOtpSignInErrorState(failure1);
      } else if (type == "signUp") {
        return SendOtpSignUpErrorState(failure1);
      } else {
        return SendOtpErrorState(failure1);
      }
    }, (data) {
      if (type == "signIn") {
        return SendOtpSignInSuccessState(data);
      } else if (type == "signUp") {
        return SendOtpSignUpSuccessState(data);
      } else {
        return SendOtpSuccessState(data);
      }
    });
  }

  void makeRegister(String phone,
      String countryId,
      String email,
      String codeOtp,
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
        codeOtp,
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

  void makeLogin(String phone, String countryId, String code) async {
    emit(SignInLoading());
    loginUseCase.execute(phone, countryId, code).then((value) {
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
}