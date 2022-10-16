import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/domain/repository/InfoBranchRepository.dart';

class InfoPlaceBranchUseCase {
  final InfoBranchRepository infoBranchRepository;

  InfoPlaceBranchUseCase(this.infoBranchRepository);

  Future<Either<String, Data?>> execute(String id) {
    return infoBranchRepository.getInfoPlace(id);
  }
}
