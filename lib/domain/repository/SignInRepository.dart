import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';

abstract class SignInRepository {
  Future<Either<String, List<Data>?>> getCountries();

  Future<Either<String, List<DataRole>?>> getRole();

  Future<Either<String, SendOtpData>> sendOtp(String type, String phone, String countryId);

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
