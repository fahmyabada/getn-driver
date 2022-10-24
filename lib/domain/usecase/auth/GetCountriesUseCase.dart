import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class GetCountriesUseCase {
  final AuthRepository signInRepository;

  GetCountriesUseCase(this.signInRepository);

  Future<Either<String, List<Country>?>> execute() {
    return signInRepository.getCountries();
  }
}
