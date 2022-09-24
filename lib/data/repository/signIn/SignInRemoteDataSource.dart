import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/role/Role.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:http_parser/http_parser.dart';

abstract class SignInRemoteDataSource {
  Future<Either<String, List<Data>?>> getCountries();

  Future<Either<String, List<DataRole>?>> getRole();

  Future<Either<String, SendOtpData>> sendOtp(String phone, String countryId);

  Future<Either<String, SignModel>> login(
      String phone, String countryId, String code);

  Future<Either<String, SignModel>> register(
      String phone,
      String countryId,
      String email,
      String codeOtp,
      String fullName,
      String role,
      bool terms,
      String photo);

  Future<Either<String, SignModel>> editInformationUserUseCase(FormData data);
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
            return const Left("Not Found Countries");
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
  Future<Either<String, List<DataRole>?>> getRole() async {
    try {
      var body = {"select": "title type", "app": "driver-app"};

      return await DioHelper.getData(url: 'role', query: body).then((value) {
        if (value.statusCode == 200) {
          if (Role.fromJson(value.data).data != null) {
            return Right(Role.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Roles");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception {
      return const Left("you have error when get Roles");
    }
  }

  @override
  Future<Either<String, SendOtpData>> sendOtp(
      String phone, String countryId) async {
    try {
      var formData = FormData.fromMap({
        'phone': phone,
        'country': countryId,
        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });

      return await DioHelper.postData2(
              url: 'driver/auth/send-otp', data: formData)
          .then((value) {
        if (value.statusCode == 200) {
          if (SendOtpData.fromJson(value.data).isAlreadyUser != null) {
            return Right(SendOtpData.fromJson(value.data));
          } else {
            return Left(SendOtpData.fromJson(value.data).message!.toString());
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
  Future<Either<String, SignModel>> register(
      String phone,
      String countryId,
      String email,
      String codeOtp,
      String fullName,
      String role,
      bool terms,
      String photo) async {
    try {
      String fileName = photo.split('/').last;
      // String mimeType = mime(fileName);
      // String mimee = mimeType.split('/')[0];
      // String type = mimeType.split('/')[1];

      var formData = FormData.fromMap({
        'phone': phone,
        'country': countryId,
        'verifyCode': codeOtp,
        'role': role,
        'email': email,
        'verifyImage': await MultipartFile.fromFile(photo, filename: fileName, contentType: MediaType("image", "jpeg")),
        'acceptTermsAndConditions': terms,
      });

      const headers = 'multipart/form-data';
      print("formData**********************${fileName}");

      return await DioHelper.postData2(
              url: 'driver/auth/register', data: formData, header: headers)
          .then((value) {
        if (value.statusCode == 200) {
          if (SignModel.fromJson(value.data).id != null) {
            return Right(SignModel.fromJson(value.data));
          } else {
            print("register**********************${value.data.toString()}");
            return Left(value.data.toString());
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
  Future<Either<String, SignModel>> login(
      String phone, String countryId, String code) async {
    try {
      var formData = FormData.fromMap({
        'phone': phone,
        'country': countryId,
        'verifyCode': code,
      });
      return await DioHelper.postData2(url: 'driver/auth/login', data: formData)
          .then((value) {
        if (value.statusCode == 200) {
          if (SignModel.fromJson(value.data).id != null) {
            return Right(SignModel.fromJson(value.data));
          } else {
            return Left(SignModel.fromJson(value.data).message!.toString());
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
  Future<Either<String, SignModel>> editInformationUserUseCase(FormData data) async{
    try {
      return await DioHelper.putData2(url: 'driver/auth/edit-profile', data: data)
          .then((value) {
        if (value.statusCode == 200) {
          if (SignModel.fromJson(value.data).id != null) {
            return Right(SignModel.fromJson(value.data));
          } else {
            return Left(SignModel.fromJson(value.data).message!.toString());
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
