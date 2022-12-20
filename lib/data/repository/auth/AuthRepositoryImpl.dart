import 'package:dartz/dartz.dart';
import 'package:dio/src/form_data.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/data/repository/auth/AuthRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.authRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, List<Country>?>> getCountries() async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getCountries().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, List<Country>?>> getArea(
      String countryId, String cityId) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource
          .getArea(countryId, cityId)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, List<Country>?>> getCities(String countryId) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getCities(countryId).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> getCarSubCategory() async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getCarSubCategory().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> getCarModel() async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getCarModel().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> getColor() async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getColor().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, List<DataRole>?>> getRole() async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getRole().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, SendOtpData>> sendOtp(
      String type, String phone, String countryId) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource
          .sendOtp(type, phone, countryId)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, SignModel>> register(
      FormData data, String firebaseToken) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource
          .register(data, firebaseToken)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, SignModel>> login(
      String phone, String countryId, String firebaseToken) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource
          .login(phone, countryId, firebaseToken)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, EditProfileModel>> editInformationUser(
      FormData data) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.editInformationUser(data).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, CarRegisterationModel?>> carCreate(
      FormData data) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.carCreate(data).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }
}
