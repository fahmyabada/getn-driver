import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/recomendPlace/Data.dart';
import 'package:getn_driver/data/repository/infoPlace/InfoPlaceRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/InfoPlaceRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class InfoPlaceRepositoryImpl extends InfoPlaceRepository {
  final InfoPlaceRemoteDataSource infoPlaceRemoteDataSource;
  final NetworkInfo networkInfo;

  InfoPlaceRepositoryImpl(this.infoPlaceRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, Data?>> getInfoPlace(String id, String type) async {
    if (await networkInfo.isConnected) {
      if (type == "Branch") {
        return await infoPlaceRemoteDataSource.getInfoBranch(id).then((value) {
          return value.fold((failure) {
            return Left(failure.toString());
          }, (data) {
            return Right(data);
          });
        });
      } else {
        return await infoPlaceRemoteDataSource.getInfoPlace(id).then((value) {
          return value.fold((failure) {
            return Left(failure.toString());
          }, (data) {
            return Right(data);
          });
        });
      }
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }
}
