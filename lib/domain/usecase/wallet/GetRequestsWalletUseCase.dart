import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/domain/repository/WalletRepository.dart';

class GetRequestsWalletUseCase {
  final WalletRepository walletRepository;

  GetRequestsWalletUseCase(this.walletRepository);

  Future<Either<String, WalletModel?>> execute(int index) {
    return walletRepository.getRequests(index);
  }
}
