import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/country/Data.dart';

abstract class EditProfileRemoteDataSource {
  Future<Either<String, EditProfileModel?>> getProfileDetails();

  Future<Either<String, List<Data>?>> getCountries();

  Future<Either<String, List<Data>?>> getCities(String countryId);

  Future<Either<String, List<Data>?>> getArea(String countryId, String cityId);
}

class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  @override
  Future<Either<String, EditProfileModel?>> getProfileDetails() async {
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
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<Data>?>> getArea(String countryId, String cityId) async{
    try {
      var body = {
        "country": countryId,
        "city": countryId,
        "limit": 999,
      };
      return await DioHelper.getData(url: 'area', query: body).then((value) {
        if (value.statusCode == 200) {
          if (CountryData.fromJson(value.data).data != null) {
            return Right(CountryData.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Area");
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
  Future<Either<String, List<Data>?>> getCities(String countryId) async {
    try {
      var body = {
        "country": countryId,
        "limit": 999,
      };
      return await DioHelper.getData(url: 'city', query: body).then((value) {
        if (value.statusCode == 200) {
          if (CountryData.fromJson(value.data).data != null) {
            return Right(CountryData.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Cities");
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
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }
}
