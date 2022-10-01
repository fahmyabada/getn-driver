import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetRequestDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'request_details_state.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  RequestDetailsCubit() : super(RequestDetailsInitial());

  static RequestDetailsCubit get(context) => BlocProvider.of(context);

  var getRequestDetailsUseCase = getIt<GetRequestDetailsUseCase>();

  DataRequest? requestDetails;

  void getRequestDetails(String id) async {
    emit(RequestDetailsInitial());

    getRequestDetailsUseCase.execute(id).then((value) {
      emit(eitherLoadedOrErrorStateRequestDetails(value));
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateRequestDetails(
      Either<String, DataRequest?> data) {
    return data.fold((failure1) {
      return RequestDetailsErrorState(failure1);
    }, (data) {
      requestDetails = data;
      return RequestDetailsSuccessState(data);
    });
  }
}
