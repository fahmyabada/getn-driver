import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class RegisterUseCase {
  final AuthRepository signInRepository;

  RegisterUseCase(this.signInRepository);

  Future<Either<String, SignModel>> execute(
      FormData data, String firebaseToken) {
    return signInRepository.register(data, firebaseToken);
  }
}
