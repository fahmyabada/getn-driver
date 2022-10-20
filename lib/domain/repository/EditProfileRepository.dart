import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';

import '../../data/model/country/Data.dart';

abstract class EditProfileRepository {
  Future<Either<String, EditProfileModel?>> getProfileDetails();

  Future<Either<String, List<Data>?>> getCountries();

  Future<Either<String, List<Data>?>> getCities(String countryId);

  Future<Either<String, List<Data>?>> getArea(String countryId, String cityId);
}
