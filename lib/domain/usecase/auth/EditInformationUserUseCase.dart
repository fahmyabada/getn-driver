import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class EditInformationUserUseCase {
  final AuthRepository signInRepository;

  EditInformationUserUseCase(this.signInRepository);

  Future<Either<String, EditProfileModel>> execute(
    FormData data,
  ) {
    return signInRepository.editInformationUser(data);
  }
}
