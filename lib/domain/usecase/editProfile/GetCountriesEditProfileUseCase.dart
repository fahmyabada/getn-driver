import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class GetCountriesEditProfileUseCase {
  final EditProfileRepository editProfileRepository;

  GetCountriesEditProfileUseCase(this.editProfileRepository);

  Future<Either<String, List<Data>?>> execute() {
    return editProfileRepository.getCountries();
  }
}
