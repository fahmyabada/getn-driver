import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class GetAreaAuthUseCase {
  final AuthRepository authRepository;

  GetAreaAuthUseCase(this.authRepository);

  Future<Either<String, List<Country>?>> execute(String countryId, String cityId) {
    return authRepository.getArea(countryId, cityId);
  }
}
