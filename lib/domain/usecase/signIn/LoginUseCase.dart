import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class LoginUseCase {
  final SignInRepository signInRepository;

  LoginUseCase(this.signInRepository);

  Future<Either<String, SignModel>> execute(
    String phone,
    String countryId,
    String firebaseToken,
  ) {
    return signInRepository.login(phone, countryId, firebaseToken);
  }
}
