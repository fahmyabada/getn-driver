import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/repository/signIn/SignInRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class SignInRepositoryImpl extends SignInRepository {
  final SignInRemoteDataSource signInRemoteDataSource;
  final NetworkInfo networkInfo;

  SignInRepositoryImpl(this.signInRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, List<Data>?>> getCountries() async{
    if (await networkInfo.isConnected) {
      final remoteLogin = await signInRemoteDataSource.getCountries();
      return remoteLogin.fold((failure) {
        return Left(failure.toString());
      }, (data) {
        return Right(data);
      });
    } else {
      return Left(networkFailureMessage);
    }
  }
}
