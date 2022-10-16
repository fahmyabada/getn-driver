import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/domain/repository/BranchesPlaceRepository.dart';
import 'package:getn_driver/domain/repository/InfoBranchRepository.dart';

class GetBranchesInfoBranchUseCase {
  final InfoBranchRepository infoBranchRepository;

  GetBranchesInfoBranchUseCase(this.infoBranchRepository);

  Future<Either<String, RecomendPlaces?>> execute(Map<String, dynamic> body) {
    return infoBranchRepository.getBranches(body);
  }
}
