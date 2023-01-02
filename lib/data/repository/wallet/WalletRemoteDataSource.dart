import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/model/wallet/WalletModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/wallet/Data.dart';

abstract class WalletRemoteDataSource {
  Future<Either<String, WalletModel?>> getWallet(int index);

  Future<Either<String, WalletModel?>> getRequests(int index);

  Future<Either<String, List<Country>?>> getCountries();

  Future<Either<String, Data?>> createRequestTransaction(String body);
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  @override
  Future<Either<String, WalletModel>> getWallet(int index) async {
    try {
      var body = {"page": index, "sort": 'createdAt: -1'};
      return await DioHelper.getData(
              url: 'walletTransactions',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(WalletModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, WalletModel?>> getRequests(int index) async {
    try {
      var body = {"page": index, "sort": 'createdAt: -1'};
      return await DioHelper.getData(
              url: 'requestTransactions',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(WalletModel.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, List<Country>?>> getCountries() async {
    try {
      var body = {
        "limit": 999,
      };
      return await DioHelper.getData(url: 'country', query: body).then((value) {
        if (value.statusCode == 200) {
          if (CountryData.fromJson(value.data).data != null) {
            return Right(CountryData.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Countries");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, Data>> createRequestTransaction(String body) async {
    try {
      return await DioHelper.postData(
              url: 'requestTransactions',
              data: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          print(
              'requestTransactions****************** ${Data.fromJson(value.data).toString()}');
          if (Data.fromJson(value.data).id != null) {
            return Right(Data.fromJson(value.data!));
          } else {
            return const Left("occurred error in create request transactions");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }
}
