import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/wallet/Data.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/data/repository/wallet/WalletRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/WalletRepository.dart';

class WalletRepositoryImpl extends WalletRepository {
  final WalletRemoteDataSource walletRemoteDataSource;
  final NetworkInfo networkInfo;

  WalletRepositoryImpl(this.walletRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, WalletModel?>> getWallet(int index) async {
    if (await networkInfo.isConnected) {
      return await walletRemoteDataSource.getWallet(index).then((value) {
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
  Future<Either<String, WalletModel?>> getRequests(int index) async {
    if (await networkInfo.isConnected) {
      return await walletRemoteDataSource.getRequests(index).then((value) {
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
  Future<Either<String, List<Country>?>> getCountries() async {
    if (await networkInfo.isConnected) {
      return await walletRemoteDataSource.getCountries().then((value) {
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
  Future<Either<String, Data?>> createRequestTransaction(String body) async{
    if (await networkInfo.isConnected) {
      return await walletRemoteDataSource.createRequestTransaction(body).then((value) {
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
