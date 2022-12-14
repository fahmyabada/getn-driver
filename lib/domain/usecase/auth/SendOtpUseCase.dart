import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/sendOtp/SendOtpData.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class SendOtpUseCase {
  final AuthRepository signInRepository;

  SendOtpUseCase(this.signInRepository);

  Future<Either<String, SendOtpData>> execute(
      String type, String phone, String countryId) {
    return signInRepository.sendOtp(type, phone, countryId);
  }
}
