import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/country/Data.dart';

abstract class SignInRepository {
  Future<Either<String, List<Data>?>> getCountries();
  Future<Either<String, SendOtpData>> sendOtp(String phone,String countryId);
}
