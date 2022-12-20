import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/recomendPlace/RecomendPlaces.dart';
import 'package:getn_driver/data/repository/recomendPlaces/RecomendPlacesRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/RecomendPlaceRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class RecomendPlacesRepositoryImpl extends RecomendPlaceRepository {
  final RecomendPlacesRemoteDataSource recomendPlacesRemoteDataSource;
  final NetworkInfo networkInfo;

  RecomendPlacesRepositoryImpl(
      this.recomendPlacesRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, RecomendPlaces?>> getPlaces(
      Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      return await recomendPlacesRemoteDataSource.getPlaces(body).then((value) {
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
