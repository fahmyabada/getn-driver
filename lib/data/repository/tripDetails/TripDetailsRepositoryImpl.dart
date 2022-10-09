import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/repository/tripDetails/TripDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';

class TripDetailsRepositoryImpl extends TripDetailsRepository {
  final TripDetailsRemoteDataSource tripDetailsRemoteDataSource;
  final NetworkInfo networkInfo;

  TripDetailsRepositoryImpl(this.tripDetailsRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, Data?>> getTripDetails(String id) async {
    if (await networkInfo.isConnected) {
      return await tripDetailsRemoteDataSource.getTripDetails(id).then((value) {
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
  Future<Either<String, DataRequest?>> putTrip(String id, String type) async {
    if (await networkInfo.isConnected) {
      return await tripDetailsRemoteDataSource.putTrip(id, type).then((value) {
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
