import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/requestDetails/RequestDetails.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RequestDetailsRemoteDataSource {
  Future<Either<String, RequestDetails?>> getRequestDetails(String id);
  Future<Either<String, Trips?>> getTripsRequestDetails(Map<String, dynamic> body);
}

class RequestDetailsRemoteDataSourceImpl
    implements RequestDetailsRemoteDataSource {
  @override
  Future<Either<String, RequestDetails?>> getRequestDetails(String id) async {
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
          if (RequestDetails.fromJson(value.data).id!.isNotEmpty) {
            return Right(RequestDetails.fromJson(value.data!));
          } else {
            return const Left("Not Found Request");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, Trips?>> getTripsRequestDetails(Map<String, dynamic> body) async{
    try {
      return await DioHelper.getData(
          url: 'trip',
          query: body,
          token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (Trips.fromJson(value.data).data!.isNotEmpty) {
            return Right(Trips.fromJson(value.data!));
          }  else {
            return const Left("Not Found Trip");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }
}
