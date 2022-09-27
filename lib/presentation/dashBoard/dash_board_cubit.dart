import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/domain/usecase/dashboard/GetRequestUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'dash_board_state.dart';

class DashBoardCubit extends Cubit<DashBoardState> {
  DashBoardCubit() : super(RequestInitial());

  static DashBoardCubit get(context) => BlocProvider.of(context);

  var getRequestUseCase = getIt<GetRequestUseCase>();

  List<DataRole> request = [];

  void getRequest() async {
    emit(RequestInitial());
    getRequestUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateRequest(value));
    });
  }

  DashBoardState eitherLoadedOrErrorStateRequest(
      Either<String, List<DataRole>?> data) {
    return data.fold((failure1) {
      return RequestErrorState(failure1);
    }, (data) {
      request = data!;
      print("request*********** ${request.toString()}");
      return RequestSuccessState(data);
    });
  }
}
