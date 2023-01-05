import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/api_result_model.dart';
import 'package:getn_driver/data/model/placeDetails/PlaceDetails.dart';
import 'package:getn_driver/data/model/predictionsPlaceSearch/PredictionsPlaceSearch.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TripDetailsRemoteDataSource {
  Future<Either<String, Data?>> getTripDetails(String id);

  Future<Either<String, DataRequest?>> putTrip(
      String id,
      String type,
      String comment,
      String latitude,
      String longitude,
      String place,
      String branch,
      String verifyCode);

  Future<Either<String, PredictionsPlaceSearch?>> searchLocation(String text);

  Future<Either<String, PlaceDetails?>> placeDetails(String placeId);

  Future<Either<String, APIResultModel>> setPolyLines(dynamic parameters);
}

class TripDetailsRemoteDataSourceImpl implements TripDetailsRemoteDataSource {
  @override
  Future<Either<String, Data?>> getTripDetails(String id) async {
    try {
      var body = {
        "select-client": "name image phone whatsapp",
      };

      return await DioHelper.getData(
              url: 'trip/$id',
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (Data.fromJson(value.data).id!.isNotEmpty) {
            return Right(Data.fromJson(value.data!));
          } else {
            return const Left("Not Found Request");
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
  Future<Either<String, DataRequest?>> putTrip(
      String id,
      String type,
      String comment,
      String latitude,
      String longitude,
      String place2,
      String branch, String verifyCode) async {
    try {
      String data = '';
      if (type == "reject" || type == "end") {
        await placemarkFromCoordinates(
                double.parse(latitude), double.parse(longitude))
            .then((address) {
          var place = address.first;
          if (kDebugMode) {
            print(
                "addressNameEndTrip*******${place.street!}, ${place.administrativeArea!}, ${place.subAdministrativeArea!}, ${place.country!} , place : ${place2}");
          }
          String toAddress =
              "${place.street!}, ${place.administrativeArea!}, ${place.subAdministrativeArea!}, ${place.country!}";
          if (place2.isNotEmpty && branch.isNotEmpty) {
            data = jsonEncode({
              "status": type,
              "comment": comment,
              "to": {
                "placeTitle": toAddress,
                "placeLatitude": latitude,
                "placeLongitude": longitude,
                "place": place2,
                "branch": branch,
              }
            });
          } else if (place2.isNotEmpty && branch.isEmpty) {
            data = jsonEncode({
              "status": type,
              "comment": comment,
              "to": {
                "placeTitle": toAddress,
                "placeLatitude": latitude,
                "placeLongitude": longitude,
                "place": place2,
              }
            });
          } else if (place2.isEmpty && branch.isNotEmpty) {
            data = jsonEncode({
              "status": type,
              "comment": comment,
              "to": {
                "placeTitle": toAddress,
                "placeLatitude": latitude,
                "placeLongitude": longitude,
                "branch": branch,
              }
            });
          } else {
            data = jsonEncode({
              "status": type,
              "comment": comment,
              "to": {
                "placeTitle": toAddress,
                "placeLatitude": latitude,
                "placeLongitude": longitude,
              }
            });
          }
        });
      } else {
        data = jsonEncode({
          "status": type,
          "verifyCode": verifyCode,
        });
      }

      var body = {
        "select-carCategory": 'oneKMPoints points',
      };

      return await DioHelper.putData3(
              url: 'trip/$id',
              data: data,
              query: body,
              token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          if (DataRequest.fromJson(value.data).id!.isNotEmpty) {
            return Right(DataRequest.fromJson(value.data!));
          } else {
            return const Left("have error when response trip");
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
  Future<Either<String, APIResultModel>> setPolyLines(
      dynamic parameters) async {
    try {
      return await Dio()
          .post('https://maps.googleapis.com/maps/api/directions/json',
              queryParameters: parameters)
          .then((value) async {
        if (value.statusCode == 200) {
          try {
            final responseBody = value.data;
            return Right(APIResultModel(
              success: value.statusCode == 200,
              message: responseBody['status'] ?? responseBody['error_message'],
              data: responseBody,
            ));
          } catch (error) {
            print('Error in getting result from response:\n $error');
            return const Left("cannot init result api");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception {
      return Left(serverFailureMessage);
    }
  }
}
