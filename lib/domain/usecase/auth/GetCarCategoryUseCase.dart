import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class GetCarCategoryUseCase {
  final AuthRepository authRepository;

  GetCarCategoryUseCase(this.authRepository);

  Future<Either<String, List<Data>?>> execute() {
    return authRepository.getCarCategory();
  }
}
