import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/signModel/SignModel.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class RegisterUseCase {
  final SignInRepository signInRepository;

  RegisterUseCase(this.signInRepository);

  Future<Either<String, SignModel>> execute(
      String phone,
      String countryId,
      String email,
      String codeOtp,
      String fullName,
      String role,
      bool terms,
      String photo) {
    return signInRepository.register(
        phone, countryId, email, codeOtp, fullName, role, terms, photo);
  }
}