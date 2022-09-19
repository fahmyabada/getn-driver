import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
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
  Future<Either<String, SendOtpData>> sendOtp(
      String phone, String countryId) async {
    if (await networkInfo.isConnected) {
      return await signInRemoteDataSource
          .sendOtp(phone, countryId)
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
