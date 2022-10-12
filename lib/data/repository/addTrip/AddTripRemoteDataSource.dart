import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AddTripRemoteDataSource {
  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(String text);

  Future<Either<String, PlaceDetails?>> placeDetails(String placeId);
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
}
