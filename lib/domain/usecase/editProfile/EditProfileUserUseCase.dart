import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

class EditProfileUserUseCase {
  final EditProfileRepository editProfileRepository;

  EditProfileUserUseCase(this.editProfileRepository);

  Future<Either<String, SignModel>> execute(
    FormData data,
  ) {
    return editProfileRepository.editProfileDetails(data);
  }
}
