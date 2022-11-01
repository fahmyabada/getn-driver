import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';

abstract class EditProfileRepository {
  Future<Either<String, EditProfileModel?>> getProfileDetails();

  Future<Either<String, List<Country>?>> getCountries();

  Future<Either<String, List<Country>?>> getCities(String countryId);

  Future<Either<String, List<Country>?>> getArea(String countryId, String cityId);

  Future<Either<String, EditProfileModel>> editProfileDetails(FormData data);

}
