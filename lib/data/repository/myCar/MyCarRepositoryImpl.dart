import 'package:dartz/dartz.dart';
import 'package:dio/src/form_data.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/myCar/Data.dart';
import 'package:getn_driver/data/repository/myCar/MyCarRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/MyCarRepository.dart';

class MyCarRepositoryImpl extends MyCarRepository {
  final MyCarRemoteDataSource myCarRemoteDataSource;
  final NetworkInfo networkInfo;

  MyCarRepositoryImpl(this.myCarRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, List<category.Data>?>> getCarSubCategory() async {
    if (await networkInfo.isConnected) {
      return await myCarRemoteDataSource.getCarSubCategory().then((value) {
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

  @override
  Future<Either<String, List<category.Data>?>> getCarModel() async {
    if (await networkInfo.isConnected) {
      return await myCarRemoteDataSource.getCarModel().then((value) {
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

  @override
  Future<Either<String, List<category.Data>?>> getColor() async {
    if (await networkInfo.isConnected) {
      return await myCarRemoteDataSource.getColor().then((value) {
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

  @override
  Future<Either<String, Data?>> getCar() async {
    if (await networkInfo.isConnected) {
      return await myCarRemoteDataSource.getCar().then((value) {
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

  @override
  Future<Either<String, CarRegisterationModel?>> carEdit(
      FormData data, String id) async {
    if (await networkInfo.isConnected) {
      return await myCarRemoteDataSource.carEdit(data, id).then((value) {
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
