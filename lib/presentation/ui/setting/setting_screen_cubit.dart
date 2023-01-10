import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/DeleteAccountModel.dart';
import 'package:getn_driver/domain/usecase/setting/DeleteAccountUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'setting_screen_state.dart';

class SettingScreenCubit extends Cubit<SettingScreenState> {
  SettingScreenCubit() : super(SettingScreenInitial());

  static SettingScreenCubit get(context) => BlocProvider.of(context);

  var deleteAccountUseCase = getIt<DeleteAccountUseCase>();


  void deleteAccount(String message) async {
    emit(DeleteAccountLoading());
    deleteAccountUseCase.execute(message).then((value) {
      emit(eitherLoadedOrErrorStateDeleteAccount(value));
    });
  }

  SettingScreenState eitherLoadedOrErrorStateDeleteAccount(
      Either<String, DeleteAccountModel?> data) {
    return data.fold((failure1) {
      print("DeleteAccountErrorState*********** $failure1");
      return DeleteAccountErrorState(failure1);
    }, (data) {
      print("DeleteAccountSuccessState*********** $data");

      return DeleteAccountSuccessState(data);
    });
  }
}
