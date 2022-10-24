import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class GetAreaEditProfileUseCase {
  final EditProfileRepository editProfileRepository;

  GetAreaEditProfileUseCase(this.editProfileRepository);

  Future<Either<String, List<Country>?>> execute(String countryId, String cityId) {
    return editProfileRepository.getArea(countryId, cityId);
  }
}
