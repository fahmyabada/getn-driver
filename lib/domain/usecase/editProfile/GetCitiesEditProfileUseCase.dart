import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class GetCitiesEditProfileUseCase {
  final EditProfileRepository editProfileRepository;

  GetCitiesEditProfileUseCase(this.editProfileRepository);

  Future<Either<String, List<Country>?>> execute(String countryId) {
    return editProfileRepository.getCities(countryId);
  }
}
