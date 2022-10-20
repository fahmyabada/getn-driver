import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class GetProfileDetailsUseCase {
  final EditProfileRepository editProfileRepository;

  GetProfileDetailsUseCase(this.editProfileRepository);

  Future<Either<String, EditProfileModel?>> execute() {
    return editProfileRepository.getProfileDetails();
  }
}
