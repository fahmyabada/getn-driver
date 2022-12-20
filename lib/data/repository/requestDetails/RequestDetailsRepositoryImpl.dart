import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/data/repository/requestDetails/RequestDetailsRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class RequestDetailsRepositoryImpl extends RequestDetailsRepository {
  final RequestDetailsRemoteDataSource requestDetailsRemoteDataSource;
  final NetworkInfo networkInfo;

  RequestDetailsRepositoryImpl(
      this.requestDetailsRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, DataRequest?>> getRequestDetails(String id) async {
    if (await networkInfo.isConnected) {
      return await requestDetailsRemoteDataSource
          .getRequestDetails(id)
          .then((value) {
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

  @override
  Future<Either<String, Trips?>> getTripsRequestDetails(
      Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      return await requestDetailsRemoteDataSource
          .getTripsRequestDetails(body)
          .then((value) {
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

  @override
  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment) async {
    if (await networkInfo.isConnected) {
      return await requestDetailsRemoteDataSource
          .putRequest(id, type, comment)
          .then((value) {
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

  @override
  Future<Either<String, Position>> getCurrentLocation()  async {
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

  @override
  Future<Either<String, Request>> getLastTrip(String idRequest) async{
    if (await networkInfo.isConnected) {
      return await requestDetailsRemoteDataSource
          .getLastTrip(idRequest)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data!);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }
}
