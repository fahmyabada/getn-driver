import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/myCar/Data.dart';
import 'package:getn_driver/domain/repository/MyCarRepository.dart';

class GetMyCarUseCase {
  final MyCarRepository myCarRepository;

  GetMyCarUseCase(this.myCarRepository);

  Future<Either<String, Data?>> execute() {
    return myCarRepository.getCar();
  }
}
