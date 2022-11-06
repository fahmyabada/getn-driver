import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart';
import 'package:getn_driver/domain/repository/MyCarRepository.dart';

class GetMyColorUseCase {
  final MyCarRepository myCarRepository;

  GetMyColorUseCase(this.myCarRepository);

  Future<Either<String, List<Data>?>> execute() {
    return myCarRepository.getColor();
  }
}
