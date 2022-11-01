import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';

abstract class AuthRepository {
  Future<Either<String, List<Country>?>> getCountries();

  Future<Either<String, List<Country>?>> getCities(String countryId);

  Future<Either<String, List<Country>?>> getArea(
      String countryId, String cityId);

  Future<Either<String, List<category.Data>?>> getCarSubCategory();

  Future<Either<String, List<category.Data>?>> getCarModel();

  Future<Either<String, List<category.Data>?>> getColor();

  Future<Either<String, CarRegisterationModel?>> carCreate(FormData data);

  Future<Either<String, List<DataRole>?>> getRole();

  Future<Either<String, SendOtpData>> sendOtp(
      String type, String phone, String countryId);

  Future<Either<String, SignModel>> login(
      String phone, String countryId, String firebaseToken);

  Future<Either<String, SignModel>> register(
      FormData data, String firebaseToken);

  Future<Either<String, EditProfileModel>> editInformationUser(FormData data);

}
