import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/domain/repository/MyCarRepository.dart';

class CarEditUseCase {
  final MyCarRepository myCarRepository;

  CarEditUseCase(this.myCarRepository);

  Future<Either<String, CarRegisterationModel?>> execute(
      FormData data, String id) {
    return myCarRepository.carEdit(data, id);
  }
}
