import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/CanCreateTrip/CanCreateTrip.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/repository/tripCreate/TripCreateRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/TripCreateRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class TripCreateRepositoryImpl extends TripCreateRepository {
  final TripCreateRemoteDataSource addTripRemoteDataSource;
  final NetworkInfo networkInfo;

  TripCreateRepositoryImpl(this.addTripRemoteDataSource, this.networkInfo);

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
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
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
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, Data?>> createTrip(CreateTripModel data) async {
    if (await networkInfo.isConnected) {
      return await addTripRemoteDataSource.createTrip(data).then((value) {
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

  @override
  Future<Either<String, CanCreateTrip?>> canCreateTrip(
      CreateTripModel data) async {
    if (await networkInfo.isConnected) {
      return await addTripRemoteDataSource.canCreateTrip(data).then((value) {
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
