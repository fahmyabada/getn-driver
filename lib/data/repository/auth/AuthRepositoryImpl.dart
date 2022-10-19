import 'package:dartz/dartz.dart';
import 'package:dio/src/form_data.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/country/Data.dart' as country;
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/data/repository/auth/AuthRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl(this.authRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, List<country.Data>?>> getCountries() async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.getCountries().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
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
      return Left(networkFailureMessage);
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
      return Left(networkFailureMessage);
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
      return Left(networkFailureMessage);
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
      return Left(networkFailureMessage);
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
      return Left(networkFailureMessage);
    }
  }

  @override
  Future<Either<String, SignModel>> register(
      String phone,
      String countryId,
      String email,
      String firebaseToken,
      String fullName,
      String role,
      bool terms,
      String photo) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource
          .register(phone, countryId, email, firebaseToken, fullName, role,
              terms, photo)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
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
      return Left(networkFailureMessage);
    }
  }

  @override
  Future<Either<String, SignModel>> editInformationUserUseCase(
      FormData data) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource
          .editInformationUserUseCase(data)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
    }
  }

  @override
  Future<Either<String, List<category.Data>?>> carCreate(FormData data) async {
    if (await networkInfo.isConnected) {
      return await authRemoteDataSource.carCreate(data).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
    }
  }
}
