import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class GetRoleUseCase {
  final AuthRepository signInRepository;

  GetRoleUseCase(this.signInRepository);

  Future<Either<String, List<DataRole>?>> execute() {
    return signInRepository.getRole();
  }
}
