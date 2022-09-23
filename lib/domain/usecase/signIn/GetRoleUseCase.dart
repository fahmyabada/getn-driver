import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class GetRoleUseCase {
  final SignInRepository signInRepository;

  GetRoleUseCase(this.signInRepository);

  Future<Either<String, List<DataRole>?>> execute() {
    return signInRepository.getRole();
  }
}
