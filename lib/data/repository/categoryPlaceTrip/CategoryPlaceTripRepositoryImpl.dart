import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/CategoryPlaceTrip.dart';
import 'package:getn_driver/data/repository/categoryPlaceTrip/CategoryPlaceTripRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/CategoryPlaceTripRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class CategoryPlaceTripRepositoryImpl extends CategoryPlaceTripRepository {
  final CategoryPlaceTripRemoteDataSource categoryPlaceTripRemoteDataSource;
  final NetworkInfo networkInfo;

  CategoryPlaceTripRepositoryImpl(this.categoryPlaceTripRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, CategoryPlaceTrip?>> getCategoryPlace(int index) async{
    if (await networkInfo.isConnected) {
      return await categoryPlaceTripRemoteDataSource.getCategoryPlace(index).then((value) {
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
