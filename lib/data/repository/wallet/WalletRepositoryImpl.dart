import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
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
}
