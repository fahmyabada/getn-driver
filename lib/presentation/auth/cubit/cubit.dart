import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/domain/usecase/signIn/GetCountriesUseCase.dart';
import 'package:getn_driver/domain/usecase/signIn/SendOtpUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(SignInitial());

  static SignCubit get(context) => BlocProvider.of(context);

  var getPlanVisitUseCase = getIt<GetCountriesUseCase>();
  var sendOtpUseCase = getIt<SendOtpUseCase>();
  List<Data> countries = [];

  void getCountries() async {
    emit(CountriesLoading());
    getPlanVisitUseCase.execute().then((value) {
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

  void sendOtp(String phone, String countryId) async {
    emit(SendOtpLoading());
    sendOtpUseCase.execute(phone, countryId).then((value) {
      emit(eitherLoadedOrErrorStateSendOtp(value));
    });
  }

  SignState eitherLoadedOrErrorStateSendOtp(
      Either<String, SendOtpData> data) {
    return data.fold((failure1) {
      return SendOtpErrorState(failure1);
    }, (data) {
      return SendOtpSuccessState(data);
    });
  }
}

