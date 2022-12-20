import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/data/repository/infoBranch/InfoBranchRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/InfoBranchRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class InfoBranchRepositoryImpl extends InfoBranchRepository {
  final InfoBranchRemoteDataSource infoBranchRemoteDataSource;
  final NetworkInfo networkInfo;

  InfoBranchRepositoryImpl(this.infoBranchRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, Data?>> getInfoPlace(String id) async {
    if (await networkInfo.isConnected) {
      return await infoBranchRemoteDataSource.getInfoPlace(id).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }

  @override
  Future<Either<String, RecomendPlaces?>> getBranches(
      Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      return await infoBranchRemoteDataSource.getBranches(body).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }
}
