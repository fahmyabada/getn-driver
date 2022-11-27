import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/carCategory/CarCategory.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/role/Role.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
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

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Either<String, List<Country>?>> getCountries() async {
    try {
      var body = {
        "limit": 999,
      };
      return await DioHelper.getData(url: 'country', query: body).then((value) {
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
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<Country>?>> getArea(
      String countryId, String cityId) async {
    try {
      var body = {
        "country": countryId,
        "city": cityId,
        "limit": 999,
      };
      print("getArea*********** ${body.toString()}");
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
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<Country>?>> getCities(String countryId) async {
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
    } catch (error) {
      return Left(handleError(error));
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
    } catch (error) {
      return Left(handleError(error));
    }
    // {
    //   return const Left("you have error when get Roles");
    // }
  }

  @override
  Future<Either<String, SendOtpData>> sendOtp(
      String type, String phone, String countryId) async {
    try {
      var formData = FormData.fromMap({
        'phone': phone,
        'country': countryId,
      });
      var query = {
        'type': type,
      };
      const apiKey =
          'fjsadkjfgdshfgjhjhvmgfdhvjkhdfjkhgkljfklghg54654654j65g456hk456hj4k6546hj4k64jh6k';
      print('*******type = $type');

      return await DioHelper.postData2(
              url: 'driver/auth/send-otp',
              data: formData,
              query: query,
              apiKey: apiKey)
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
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, SignModel>> register(
      FormData data, String firebaseToken) async {
    try {
      const headers = 'multipart/form-data';
      const apiKey =
          'fjsadkjfgdshfgjhjhvmgfdhvjkhdfjkhgkljfklghg54654654j65g456hk456hj4k6546hj4k64jh6k';

      return await DioHelper.postData2(
              url: 'driver/auth/register',
              data: data,
              header: headers,
              apiKey: apiKey,
              firebaseToken: firebaseToken)
          .then((value) {
        if (value.statusCode == 200) {
          if (SignModel.fromJson(value.data).id != null) {
            return Right(SignModel.fromJson(value.data));
          } else {
            return Left(value.data.toString());
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, SignModel>> login(
      String phone, String countryId, String firebaseToken) async {
    try {
      var formData = FormData.fromMap({
        'lang': getIt<SharedPreferences>().getBool('isEn')! ? 'en' : 'ar',
        'phone': phone,
        'country': countryId,
        'fcmToken': getIt<SharedPreferences>().getString("fcmToken"),
      });
      const apiKey =
          'fjsadkjfgdshfgjhjhvmgfdhvjkhdfjkhgkljfklghg54654654j65g456hk456hj4k6546hj4k64jh6k';

      return await DioHelper.postData2(
              url: 'driver/auth/login',
              data: formData,
              apiKey: apiKey,
              firebaseToken: firebaseToken)
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
            print(
                'token fcm=****************** ${EditProfileModel.fromJson(value.data).fcmToken}');
            return Right(EditProfileModel.fromJson(value.data));
          } else {
            return Left(
                EditProfileModel.fromJson(value.data).message!.toString());
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> getCarSubCategory() async {
    try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'car-subcategory', query: body)
          .then((value) {
        if (value.statusCode == 200) {
          if (CarCategory.fromJson(value.data).data != null) {
            return Right(CarCategory.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Car Category");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> getCarModel() async {
    try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'car-model', query: body)
          .then((value) {
        if (value.statusCode == 200) {
          if (CarCategory.fromJson(value.data).data != null) {
            return Right(CarCategory.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Car Model");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> getColor() async {
    try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'color', query: body).then((value) {
        if (value.statusCode == 200) {
          if (CarCategory.fromJson(value.data).data != null) {
            return Right(CarCategory.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Color");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, CarRegisterationModel?>> carCreate(
      FormData data) async {
    try {
      return await DioHelper.postData3(
              url: 'car',
              data: data,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(CarRegisterationModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }
}
