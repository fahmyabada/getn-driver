import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/DeleteAccountModel.dart';
import 'package:getn_driver/data/repository/setting/SettingRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/SettingRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class SettingRepositoryImpl extends SettingRepository {
  final SettingRemoteDataSource settingRemoteDataSource;
  final NetworkInfo networkInfo;

  SettingRepositoryImpl(this.settingRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, DeleteAccountModel?>> deleteAccount(
      String message) async {
    if (await networkInfo.isConnected) {
      return await settingRemoteDataSource.deleteAccount(message).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data!);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }
}
