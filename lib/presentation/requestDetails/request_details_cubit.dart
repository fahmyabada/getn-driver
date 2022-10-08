import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/domain/usecase/request/PutRequestUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetRequestDetailsUseCase.dart';
import 'package:getn_driver/domain/usecase/requestDetails/GetTripsRequestDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

part 'request_details_state.dart';

class RequestDetailsCubit extends Cubit<RequestDetailsState> {
  RequestDetailsCubit() : super(RequestDetailsInitial());

  static RequestDetailsCubit get(context) => BlocProvider.of(context);

  var getRequestDetailsUseCase = getIt<GetRequestDetailsUseCase>();
  var getTripsRequestDetailsUseCase = getIt<GetTripsRequestDetailsUseCase>();
  var putRequestUseCase = getIt<PutRequestUseCase>();

  DataRequest? requestDetails;
  List<Data> trips = [];
  int indexTrips = 0;
  bool loadingMoreTrips = false;
  bool loadingTrips = false;
  bool loadingRequest = false;
  String failureRequest = "";
  String failureTrip = "";

  void getRequestDetails(String id) async {
    emit(RequestDetailsInitial());
    loadingRequest = true;
    getRequestDetailsUseCase.execute(id).then((value) {
      emit(eitherLoadedOrErrorStateRequestDetails(value, id));
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateRequestDetails(
      Either<String, DataRequest?> data, String id) {
    return data.fold((failure1) {
      loadingRequest = false;
      failureRequest = failure1;
      return RequestDetailsErrorState(failure1);
    }, (data) {
      requestDetails = data;
      loadingRequest = false;
      final currentDate = DateTime.now();
      final d = DateFormat("yyyy-MM-ddTHH:mm")
          .parse(requestDetails!.from!.date!)
          .subtract(
        const Duration(
          hours: 24,
        ),
      );

      print('date****************** $d');
      print('date1****************** ${currentDate.isBefore(d)}');
      return RequestDetailsSuccessState(data);
    });
  }

  void getTripsRequestDetails(int index, String id) async {
    var body = {"request": id, "page": index};
    if (index > 1) {
      getTripsRequestDetailsUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateTripsRequestDetails2(value));
      });
    } else {
      emit(TripsInitial());
      loadingTrips = true;
      getTripsRequestDetailsUseCase.execute(body).then((value) {
        emit(eitherLoadedOrErrorStateTripsRequestDetails(value));
      });
    }
  }

  RequestDetailsState eitherLoadedOrErrorStateTripsRequestDetails(
      Either<String, Trips?> data) {
    return data.fold((failure1) {
      failureTrip = failure1;
      loadingTrips = false;
      return TripsErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        trips.clear();
        trips.addAll(data.data!);
        indexTrips = indexTrips + 1;
        loadingMoreTrips = true;
      }
      loadingTrips = false;
      return TripsSuccessState(data);
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateTripsRequestDetails2(
      Either<String, Trips?> data) {
    return data.fold((failure1) {
      return TripsErrorState(failure1);
    }, (data) {
      if (data!.data!.isNotEmpty) {
        if (data.totalCount! >= trips.length) {
          loadingMoreTrips = true;
          trips.addAll(data.data!);
          indexTrips = indexTrips + 1;
        } else {
          loadingMoreTrips = false;
        }
      }
      return TripsSuccessState(data);
    });
  }

  void editRequest(String id, String type, String comment) async {
    emit(RequestDetailsEditInitial());

    putRequestUseCase.execute(id, type, comment).then((value) {
      emit(eitherLoadedOrErrorStateRequestEdit(value));
    });
  }

  RequestDetailsState eitherLoadedOrErrorStateRequestEdit(
      Either<String, DataRequest?> data) {
    return data.fold((failure1) {
      return RequestDetailsEditErrorState(failure1);
    }, (data) {
      return RequestDetailsEditSuccessState(data);
    });
  }
}
