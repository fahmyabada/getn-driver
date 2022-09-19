import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class SignInRemoteDataSource {
  Future<Either<String, List<Data>?>> getCountries();

  Future<Either<String, SendOtpData>> sendOtp(String phone, String countryId);
}

class SignInRemoteDataSourceImpl implements SignInRemoteDataSource {
  @override
  Future<Either<String, List<Data>?>> getCountries() async {
    try {
      return await DioHelper.getData(url: 'country').then((value) {
        if (value.statusCode == 200) {
          if (CountryData.fromJson(value.data).data != null) {
            return Right(CountryData.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Data");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception {
      return const Left("you have error when get Countries");
    }
  }

  @override
  Future<Either<String, SendOtpData>> sendOtp(
      String phone, String countryId) async {
    try {
      var formData = FormData.fromMap({
        'phone': phone,
        'country': countryId,
      });

      return await DioHelper.postData2(
              url: 'driver/auth/send-otp', data: formData)
          .then((value) {
        if (value.statusCode == 200) {
          if (SendOtpData.fromJson(value.data).isAlreadyUser != null) {
            return Right(SendOtpData.fromJson(value.data));
          } else {
            return Left(SendOtpData.fromJson(value.data).message!.phone!);
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
