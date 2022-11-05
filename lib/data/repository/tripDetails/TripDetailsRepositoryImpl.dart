import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/api_result_model.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/repository/tripDetails/TripDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  Future<Either<String, DataRequest?>> putTrip(
      String id, String type, String comment) async {
    if (await networkInfo.isConnected) {
      return await tripDetailsRemoteDataSource
          .putTrip(id, type, comment)
          .then((value) {
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
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(
      String text) async {
    if (await networkInfo.isConnected) {
      return await tripDetailsRemoteDataSource
          .searchLocation(text)
          .then((value) {
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
      return await tripDetailsRemoteDataSource
          .placeDetails(placeId)
          .then((value) {
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
  Future<Either<String, APIResultModel>> setPolyLines(
      LatLng l1, LatLng l2) async {
    if (await networkInfo.isConnected) {
      try {
        final body = {
          'origin': '${l1.latitude},${l1.longitude}',
          'destination': '${l2.latitude},${l2.longitude}',
          'key': 'AIzaSyAERKSFYMxdSR6mrMmgyesmQOr8miAFd4c',
        };

        return await tripDetailsRemoteDataSource.setPolyLines(body).then((value) {
          return value.fold((failure1) => Left(failure1.toString()),
                  (data1) async {
                return Right(data1);
              });
        });
      } on Exception catch (error) {
        return Left(error.toString());
      }
    } else {
      return const Left("فشل في الاتصال");
    }
  }
}
