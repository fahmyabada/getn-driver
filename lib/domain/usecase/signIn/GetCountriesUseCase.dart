import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class GetCountriesUseCase {
  final SignInRepository signInRepository;

  GetCountriesUseCase(this.signInRepository);

  Future<Either<String, List<Data>?>> execute() {
    return signInRepository.getCountries();
  }
}