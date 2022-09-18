import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/IconModel.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of(context);

  late final selectedCountry = CountryData(
      title: {"ar": "مصر", "en": "Egypt"},
      code: '+20',
      id: "62d6edd71da20a7e80892617",
      icon: IconModel(
          src:
          "https://apis.getn.re-comparison.com/upload/country/1658254219700icon-file.webp"));



  void setSelectedCountry(value) {
    //selectedCountry = Data().obs;
    selectedCountry = value;
  }
}
