import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class EditProfileUserUseCase {
  final EditProfileRepository editProfileRepository;

  EditProfileUserUseCase(this.editProfileRepository);

  Future<Either<String, EditProfileModel>> execute(
    FormData data,
  ) {
    return editProfileRepository.editProfileDetails(data);
  }
}
