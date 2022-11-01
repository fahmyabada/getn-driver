import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';

import '../../data/model/wallet/Data.dart';

abstract class WalletRepository {
  Future<Either<String, WalletModel?>> getWallet(int index);
  Future<Either<String, WalletModel?>> getRequests(int index);
  Future<Either<String, List<Country>?>> getCountries();
  Future<Either<String, Data?>> createRequestTransaction(String body);
}
