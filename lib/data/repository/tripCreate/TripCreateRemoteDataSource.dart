import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/CanCreateTrip/CanCreateTrip.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TripCreateRemoteDataSource {
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(String text);

  Future<Either<String, PlaceDetails?>> placeDetails(String placeId);

  Future<Either<String, Data?>> createTrip(CreateTripModel data);

  Future<Either<String, CanCreateTrip?>> canCreateTrip(CreateTripModel data);
}

class TripCreateRemoteDataSourceImpl implements TripCreateRemoteDataSource {
  @override
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(
      String text) async {
    try {
      var body = {
        "input": text,
        "key": Platform.isIOS ? apiKeyIos : apiKeyAndroid
      };

      return await DioHelper.getData(
              url:
                  'https://maps.googleapis.com/maps/api/place/autocomplete/json',
              query: body)
          .then((value) {
        if (value.statusCode == 200) {
          if (PredictionsPlaceSearch.fromJson(value.data)
              .predictions!
              .isNotEmpty) {
            return Right(PredictionsPlaceSearch.fromJson(value.data!));
          } else {
            return const Left("have error when response location");
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
  Future<Either<String, PlaceDetails?>> placeDetails(String placeId) async {
    try {
      var body = {
        "place_id": placeId,
        "key": Platform.isIOS ? apiKeyIos : apiKeyAndroid
      };

      return await DioHelper.getData(
              url: 'https://maps.googleapis.com/maps/api/place/details/json',
              query: body)
          .then((value) {
        if (value.statusCode == 200) {
          if (PlaceDetails.fromJson(value.data)
                  .result
                  ?.geometry
                  ?.location
                  ?.lat !=
              null) {
            return Right(PlaceDetails.fromJson(value.data!));
          } else {
            return const Left("have error when response details location");
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
  Future<Either<String, Data?>> createTrip(CreateTripModel data) async {
    try {
      var body = jsonEncode({
        "from": {
          "placeTitle": data.from?.placeTitle,
          "placeLatitude": data.from?.placeLatitude,
          "placeLongitude": data.from?.placeLongitude
        },
        // "startDate": data.startDate,
        "to": {
          "placeTitle": data.to?.placeTitle,
          "placeLatitude": data.to?.placeLatitude,
          "placeLongitude": data.to?.placeLongitude,
          "place": data.placeId!.isNotEmpty ? data.placeId : null,
          "branch": data.branchId!.isNotEmpty ? data.branchId : null
        },
        "request": data.request,
        // "consumptionKM": data.consumptionKM.toString()
      });

      print("trip****************** ${body.toString()}");

      return await DioHelper.postData(
              url: 'trip',
              data: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (Data.fromJson(value.data).id!.isNotEmpty) {
            return Right(Data.fromJson(value.data!));
          } else {
            return const Left("have error when response create trip");
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
  Future<Either<String, CanCreateTrip?>> canCreateTrip(
      CreateTripModel data) async {
    try {
      var body = jsonEncode({
        "from": {
          "placeTitle": data.from?.placeTitle,
          "placeLatitude": data.from?.placeLatitude,
          "placeLongitude": data.from?.placeLongitude
        },
        "to": {
          "placeTitle": data.to?.placeTitle,
          "placeLatitude": data.to?.placeLatitude,
          "placeLongitude": data.to?.placeLongitude,
          "place": data.placeId!.isNotEmpty ? data.placeId : null,
          "branch": data.branchId!.isNotEmpty ? data.branchId : null
        },
        "request": data.request,
      });

      print("can_create_trip****************** ${body.toString()}");

      return await DioHelper.postData(
              url: 'trip/can_create_trip',
              data: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          return Right(CanCreateTrip.fromJson(value.data!));
        } else {
          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      return Left(handleError(error));
    }
  }
}
