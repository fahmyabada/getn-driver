import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  bool isEn = true;

  static LanguageCubit get(context) => BlocProvider.of(context);

  Map<String, Object> textAr = {
    "Arabic": "عربي",
    "English": "إنجليزي",
  };

  Map<String, Object> textEn = {
    "Arabic": "Arabic",
    "English": "English",
  };

  changeLan(bool lan) {
    isEn = lan;
    getIt<SharedPreferences>().setBool("isEn", isEn);
    emit(LanguageEnState(isEn));
  }

  Object? getTexts(String txt) {
    if (isEn == true) return textEn[txt];
    return textAr[txt];
  }
}
