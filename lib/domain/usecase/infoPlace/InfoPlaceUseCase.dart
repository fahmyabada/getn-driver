import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/domain/repository/InfoPlaceRepository.dart';

class InfoPlaceUseCase {
  final InfoPlaceRepository infoPlaceRepository;

  InfoPlaceUseCase(this.infoPlaceRepository);

  Future<Either<String, Data?>> execute(String id, String type) {
    return infoPlaceRepository.getInfoPlace(id,type);
  }
}
