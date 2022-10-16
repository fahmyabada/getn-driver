import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/domain/repository/BranchesPlaceRepository.dart';

class GetBranchesPlacesUseCase {
  final BranchesPlaceRepository branchesPlaceRepository;

  GetBranchesPlacesUseCase(this.branchesPlaceRepository);

  Future<Either<String, RecomendPlaces?>> execute(Map<String, dynamic> body) {
    return branchesPlaceRepository.getBranches(body);
  }
}
