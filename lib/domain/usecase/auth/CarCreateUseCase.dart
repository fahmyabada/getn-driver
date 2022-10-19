import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/domain/repository/AuthRepository.dart';

class CarCreateUseCase {
  final AuthRepository authRepository;

  CarCreateUseCase(this.authRepository);

  Future<Either<String, List<Data>?>> execute(FormData data) {
    return authRepository.carCreate(data);
  }
}
