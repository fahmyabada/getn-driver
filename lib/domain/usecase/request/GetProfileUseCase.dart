import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';

class GetProfileUseCase {
  final RequestRepository requestRepository;

  GetProfileUseCase(this.requestRepository);

  Future<Either<String, EditProfileModel?>> execute() {
    return requestRepository.getProfileDetails();
  }
}
