import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/wallet/Data.dart';
import 'package:getn_driver/domain/repository/WalletRepository.dart';

class CreateRequestsTransactionUseCase {
  final WalletRepository walletRepository;

  CreateRequestsTransactionUseCase(this.walletRepository);

  Future<Either<String, Data?>> execute(String body) {
    return walletRepository.createRequestTransaction(body);
  }
}
