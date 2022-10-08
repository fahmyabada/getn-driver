import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class RegisterUseCase {
  final AuthRepository signInRepository;

  RegisterUseCase(this.signInRepository);

  Future<Either<String, SignModel>> execute(
      String phone,
      String countryId,
      String email,
      String firebaseToken,
      String fullName,
      String role,
      bool terms,
      String photo) {
    return signInRepository.register(
        phone, countryId, email, firebaseToken, fullName, role, terms, photo);
  }
}
