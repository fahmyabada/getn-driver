import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WalletRemoteDataSource {
  Future<Either<String, WalletModel?>> getWallet(int index);
  Future<Either<String, WalletModel?>> getRequests(int index);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  @override
  Future<Either<String, WalletModel>> getWallet(int index) async {
    try {
      var body = {
        "page": index,
      };
      return await DioHelper.getData(
        url: 'walletTransactions',
        query: body,
        token: getIt<SharedPreferences>().getString("token")
      ).then((value) {
        if (value.statusCode == 200) {
          return Right(WalletModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, WalletModel?>> getRequests(int index) async{
    try {
      var body = {
        "page": index,
      };
      return await DioHelper.getData(
          url: 'requestTransactions',
          query: body,
          token: getIt<SharedPreferences>().getString("token")
      ).then((value) {
        if (value.statusCode == 200) {
          return Right(WalletModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    }  catch (error) {
      return Left(handleError(error));
    }
  }
}
