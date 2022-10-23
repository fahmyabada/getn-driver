import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class GetCitiesEditProfileUseCase {
  final EditProfileRepository editProfileRepository;

  GetCitiesEditProfileUseCase(this.editProfileRepository);

  Future<Either<String, List<Data>?>> execute(String countryId) {
    return editProfileRepository.getCities(countryId);
  }
}
