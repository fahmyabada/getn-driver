import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RequestDetailsRemoteDataSource {
  Future<Either<String, DataRequest?>> getRequestDetails(String id);

  Future<Either<String, Trips?>> getTripsRequestDetails(
      Map<String, dynamic> body);

  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment);

}

class RequestDetailsRemoteDataSourceImpl
    implements RequestDetailsRemoteDataSource {
  @override
  Future<Either<String, DataRequest?>> getRequestDetails(String id) async {
    try {
      var body = {
        "select-client": "name image",
      };

      return await DioHelper.getData(
              url: 'request/$id',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (DataRequest.fromJson(value.data).id!.isNotEmpty) {
            return Right(DataRequest.fromJson(value.data!));
          } else {
            return const Left("Not Found Request");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, Trips?>> getTripsRequestDetails(
      Map<String, dynamic> body) async {
    try {
      return await DioHelper.getData(
              url: 'trip',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (Trips.fromJson(value.data).data!.isNotEmpty) {
            return Right(Trips.fromJson(value.data!));
          } else {
            return const Left("Not Found Trip");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment) async {
    try {
      FormData? formData;
      if (type == "accept") {
        formData = FormData.fromMap({"status": type});
      } else {
        formData = FormData.fromMap({"status": type, "comment": comment});
      }

      return await DioHelper.putData(
              url: 'request/$id',
              data: formData,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (DataRequest.fromJson(value.data).id!.isNotEmpty) {
            return Right(DataRequest.fromJson(value.data!));
          } else {
            return const Left("have error when response request");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }
}
