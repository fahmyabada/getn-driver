import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
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
      String id, String type, String comment);

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
    }  catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, DataRequest?>> putTrip(
      String id, String type, String comment) async {
    try {
      FormData? formData;
      if (type != "reject" && type != "end") {
        formData = FormData.fromMap({"status": type});
      } else {
        formData = FormData.fromMap({"status": type, "comment": comment});
      }


      return await DioHelper.putData(
              url: 'trip/$id',
              data: formData,
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
    }  catch (error) {
      return Left(handleError(error));
    }
  }

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
    }  catch (error) {
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
    }  catch (error) {
      return Left(handleError(error));
    }
  }

  @override
  Future<Either<String, APIResultModel>> setPolyLines(
      dynamic parameters) async {
    try {
      return await Dio().post(
           'https://maps.googleapis.com/maps/api/directions/json', queryParameters: parameters)
          .then((value) async {
        if (value.statusCode == 200) {
          try {
            final responseBody = value.data;
            return Right(APIResultModel(
              success: value.statusCode == 200,
              message: responseBody['status'] ?? responseBody['error_message'],
              data:  responseBody,
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
