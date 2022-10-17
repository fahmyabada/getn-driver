import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class GetCarModelUseCase {
  final AuthRepository authRepository;

  GetCarModelUseCase(this.authRepository);

  Future<Either<String, List<Data>?>> execute() {
    return authRepository.getCarModel();
  }
}
