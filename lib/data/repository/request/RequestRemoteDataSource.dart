import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RequestRemoteDataSource {
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body);

  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment);

  Future<Either<String, EditProfileModel?>> getProfile();

  Future<Either<String, EditProfileModel>> editInformationUser(FormData data);
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
          return Right(Request.fromJson(value.data!));
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
      var body = {
        "select-carCategory": 'oneKMPoints points',
      };

      print("putRequest*********${formData.fields.toString()}");

      return await DioHelper.putData(
              url: 'request/$id',
              data: formData,
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (DataRequest.fromJson(value.data).id!.isNotEmpty) {
            print("putRequestRight*********${DataRequest.fromJson(value.data).id!}");
            return Right(DataRequest.fromJson(value.data!));
          } else {
            print("putRequestLeft*********");
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

  @override
  Future<Either<String, EditProfileModel?>> getProfile() async {
    try {
      return await DioHelper.getData(
          url: 'driver/auth/profile',
          token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(EditProfileModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, EditProfileModel>> editInformationUser(
      FormData data) async {
    try {
      return await DioHelper.putData2(
          url: 'driver/auth/edit-profile',
          data: data,
          token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (EditProfileModel.fromJson(value.data).id != null) {
            print('token fcm=editInformationUser****************** ${EditProfileModel.fromJson(value.data).fcmToken}');
            return Right(EditProfileModel.fromJson(value.data));
          } else {
            print('token fcm=editInformationUserError****************** ${EditProfileModel.fromJson(value.data).message!.toString()}');
            return Left(EditProfileModel.fromJson(value.data).message!.toString());
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

}
