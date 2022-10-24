import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class GetCitiesAuthUseCase {
  final AuthRepository authRepository;

  GetCitiesAuthUseCase(this.authRepository);

  Future<Either<String, List<Country>?>> execute(String countryId) {
    return authRepository.getCities(countryId);
  }
}
