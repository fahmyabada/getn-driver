import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RequestRemoteDataSource {
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body);

  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment);
}

class RequestRemoteDataSourceImpl implements RequestRemoteDataSource {
  @override
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body) async {
    try {
      return await DioHelper.getData(
              url: 'request',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (Request.fromJson(value.data).data!.isNotEmpty) {
            return Right(Request.fromJson(value.data!));
          } else {
            return const Left("Not Found Roles");
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
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }
}
