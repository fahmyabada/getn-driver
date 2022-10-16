import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/domain/usecase/infoPlace/InfoPlaceUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'info_place_state.dart';

class InfoPlaceCubit extends Cubit<InfoPlaceState> {
  InfoPlaceCubit() : super(InfoPlaceInitial());

  static InfoPlaceCubit get(context) => BlocProvider.of(context);

  var infoPlaceUseCase = getIt<InfoPlaceUseCase>();

  Data? info;

  void getInfoPlace(String id, String type) async {
    emit(GetInfoInitial());
    print("getInfoPlace******************$type");
    infoPlaceUseCase.execute(id,type).then((value) {
      emit(eitherLoadedOrErrorStateInfoPlace(value));
    });
  }

  InfoPlaceState eitherLoadedOrErrorStateInfoPlace(
      Either<String, Data?> data) {
    return data.fold((failure1) {
      return GetInfoErrorState(failure1);
    }, (data) {
      info = data;
      print("getInfoPlaceGetInfoSuccessState******************$data");
      return GetInfoSuccessState(data);
    });
  }

}
