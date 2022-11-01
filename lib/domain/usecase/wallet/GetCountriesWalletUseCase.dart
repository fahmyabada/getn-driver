import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/WalletRepository.dart';

class GetCountriesWalletUseCase {
  final WalletRepository walletRepository;

  GetCountriesWalletUseCase(this.walletRepository);

  Future<Either<String, List<Country>?>> execute() {
    return walletRepository.getCountries();
  }
}
