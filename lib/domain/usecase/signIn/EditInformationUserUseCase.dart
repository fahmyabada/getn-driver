import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class EditInformationUserUseCase {
  final SignInRepository signInRepository;

  EditInformationUserUseCase(this.signInRepository);

  Future<Either<String, SignModel>> execute(
    FormData data,
  ) {
    return signInRepository.editInformationUserUseCase(data);
  }
}
