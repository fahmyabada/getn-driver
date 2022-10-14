import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AddTripRemoteDataSource {
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(String text);

  Future<Either<String, PlaceDetails?>> placeDetails(String placeId);

  Future<Either<String, Data?>> createTrip(Data data);
}

class AddTripRemoteDataSourceImpl implements AddTripRemoteDataSource {
  @override
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(
      String text) async {
    try {
      var body = {
        "input": text,
        "key": "AIzaSyCVy_LzCTaZn-MCwJF6qElGO3gc5K0JwI8"
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
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, PlaceDetails?>> placeDetails(String placeId) async {
    try {
      var body = {
        "place_id": placeId,
        "key": "AIzaSyCVy_LzCTaZn-MCwJF6qElGO3gc5K0JwI8"
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
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, Data?>> createTrip(Data data) async {
    try {
      var body = jsonEncode({
        "from": {
          "placeTitle": data.from?.placeTitle,
          "placeLatitude": data.from?.placeLatitude,
          "placeLongitude": data.from?.placeLongitude
        },
        "startDate": data.startDate,
        "to": {
          "placeTitle": data.to?.placeTitle,
          "placeLatitude": data.to?.placeLatitude,
          "placeLongitude": data.to?.placeLongitude
        },
        "request": data.request,
        "consumptionKM": data.consumptionKM.toString()
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
    } on Exception catch (error) {
      return Left(handleError(error));
    }
  }
}
