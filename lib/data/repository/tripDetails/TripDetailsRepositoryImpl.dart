import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
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
      String id,
      String type,
      String comment,
      double consumptionPoints,
      String latitude,
      String longitude,
      String place,
      String branch) async {
    if (await networkInfo.isConnected) {
      return await tripDetailsRemoteDataSource
          .putTrip(id, type, comment, consumptionPoints, latitude, longitude,
              place, branch)
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

        return await tripDetailsRemoteDataSource
            .setPolyLines(body)
            .then((value) {
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

  @override
  Future<Either<String, Position>> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // await Geolocator.openLocationSettings();
      return const Left('Location services are denied');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return const Left('denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return const Left('deniedForever');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return Right(await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high));
  }
}
