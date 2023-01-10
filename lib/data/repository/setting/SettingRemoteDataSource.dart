import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/DeleteAccountModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingRemoteDataSource {
  Future<Either<String, DeleteAccountModel?>> deleteAccount(String message);
}

class SettingRemoteDataSourceImpl implements SettingRemoteDataSource {
  @override
  Future<Either<String, DeleteAccountModel?>> deleteAccount(
      String message) async {
    try {
      FormData formData = FormData.fromMap({"message": message});

      return await DioHelper.postData3(
              url: 'contact',
              data: formData,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(DeleteAccountModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }
}
