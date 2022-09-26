import 'package:dartz/dartz.dart';
import 'package:dio/src/form_data.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/data/repository/signIn/SignInRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class SignInRepositoryImpl extends SignInRepository {
  final SignInRemoteDataSource signInRemoteDataSource;
  final NetworkInfo networkInfo;

  SignInRepositoryImpl(this.signInRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, List<Data>?>> getCountries() async {
    if (await networkInfo.isConnected) {
      return await signInRemoteDataSource.getCountries().then((value) {
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
      return await signInRemoteDataSource.getRole().then((value) {
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
      return await signInRemoteDataSource
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
      String codeOtp,
      String fullName,
      String role,
      bool terms,
      String photo) async {
    if (await networkInfo.isConnected) {
      return await signInRemoteDataSource
          .register(
              phone, countryId, email, codeOtp, fullName, role, terms, photo)
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
      String phone, String countryId, String code) async {
    if (await networkInfo.isConnected) {
      return await signInRemoteDataSource
          .login(phone, countryId, code)
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
      return await signInRemoteDataSource
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
}
