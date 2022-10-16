import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/data/repository/branchesPlaces/BranchesPlacesRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/BranchesPlaceRepository.dart';

class BranchesPlacesRepositoryImpl extends BranchesPlaceRepository {
  final BranchesPlacesRemoteDataSource branchesPlacesRemoteDataSource;
  final NetworkInfo networkInfo;

  BranchesPlacesRepositoryImpl(
      this.branchesPlacesRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, RecomendPlaces?>> getBranches(
      Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      return await branchesPlacesRemoteDataSource
          .getBranches(body)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
    }
  }
}
