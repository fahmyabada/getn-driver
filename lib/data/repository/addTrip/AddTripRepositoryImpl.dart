import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/repository/addTrip/AddTripRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/AddTripRepository.dart';

class AddTripRepositoryImpl extends AddTripRepository {
  final AddTripRemoteDataSource addTripRemoteDataSource;
  final NetworkInfo networkInfo;

  AddTripRepositoryImpl(this.addTripRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(
      String text) async {
    if (await networkInfo.isConnected) {
      return await addTripRemoteDataSource.searchLocation(text).then((value) {
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
  Future<Either<String, PlaceDetails?>> placeDetails(String placeId) async {
    if (await networkInfo.isConnected) {
      return await addTripRemoteDataSource.placeDetails(placeId).then((value) {
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
  Future<Either<String, Data?>> createTrip(Data data) async {
    if (await networkInfo.isConnected) {
      return await addTripRemoteDataSource.createTrip(data).then((value) {
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
