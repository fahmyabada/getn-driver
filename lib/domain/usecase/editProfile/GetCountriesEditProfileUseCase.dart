import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class GetCountriesEditProfileUseCase {
  final EditProfileRepository editProfileRepository;

  GetCountriesEditProfileUseCase(this.editProfileRepository);

  Future<Either<String, List<Country>?>> execute() {
    return editProfileRepository.getCountries();
  }
}
