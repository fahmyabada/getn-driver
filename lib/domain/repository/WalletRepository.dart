import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';

abstract class WalletRepository {
  Future<Either<String, WalletModel?>> getWallet(int index);
  Future<Either<String, WalletModel?>> getRequests(int index);
}
