import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/packages/PackagesModel.dart';
import 'package:getn_driver/data/repository/packages/PackagesRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/PackagesRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class PackagesRepositoryImpl extends PackagesRepository {
  final PackagesRemoteDataSource packagesRemoteDataSource;
  final NetworkInfo networkInfo;

  PackagesRepositoryImpl(this.packagesRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, PackagesModel?>> getPackages(
      int index, String carCategory) async {
    if (await networkInfo.isConnected) {
      return await packagesRemoteDataSource
          .getPackages(index, carCategory)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }
}
