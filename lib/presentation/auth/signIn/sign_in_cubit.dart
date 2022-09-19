import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/country/IconModel.dart';
import 'package:getn_driver/data/model/country/Title.dart';
import 'package:getn_driver/domain/usecase/signIn/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/SendOtpUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of(context);

  var getPlanVisitUseCase = getIt<GetCountriesUseCase>();
  var sendOtpUseCase = getIt<SendOtpUseCase>();
  List<Data> countries = [];

  Data? selectedCountry = Data(
      title: Title(ar: "مصر", en: "Egypt"),
      code: '+20',
      id: "62d6edd71da20a7e80892617",
      icon: IconModel(
          src:
              "https://apis.getn.re-comparison.com/upload/country/1658254219700icon-file.webp"));

  void setSelectedCountry(Data value) {
    selectedCountry = value;
  }

  void getCountries() async {
    emit(CountriesLoading());
    getPlanVisitUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateCountries(value));
    });
  }

  SignInState eitherLoadedOrErrorStateCountries(
      Either<String, List<Data>?> data) {
    return data.fold((failure1) {
      return CountriesErrorState(failure1);
    }, (data) {
      countries = data!;
      return CountriesSuccessState(data);
    });
  }

  void sendOtp(String phone, String countryId) async {
    emit(SendOtpLoading());
    sendOtpUseCase.execute(phone, countryId).then((value) {
      emit(eitherLoadedOrErrorStateSendOtp(value));
    });
  }

  SignInState eitherLoadedOrErrorStateSendOtp(
      Either<String, SendOtpData> data) {
    return data.fold((failure1) {
      return SendOtpErrorState(failure1);
    }, (data) {
      return SendOtpSuccessState(data);
    });
  }
}
