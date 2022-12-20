import 'package:dartz/dartz.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';

class SignOutUseCase {
  final RequestRepository requestRepository;

  SignOutUseCase(this.requestRepository);

  Future<Either<String, String?>> execute() {
    return requestRepository.signOut();
  }
}
