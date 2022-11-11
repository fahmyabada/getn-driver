import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/carCategory/CarCategory.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import 'package:getn_driver/data/model/myCar/Data.dart';
import 'package:getn_driver/data/model/myCar/MyCarModel.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MyCarRemoteDataSource {
  Future<Either<String, Data?>> getCar();

  Future<Either<String, List<category.Data>?>> getCarSubCategory();

  Future<Either<String, List<category.Data>?>> getCarModel();

  Future<Either<String, List<category.Data>?>> getColor();

  Future<Either<String, CarRegisterationModel?>> carEdit(FormData data,String id);
}

class MyCarRemoteDataSourceImpl implements MyCarRemoteDataSource {

  @override
  Future<Either<String, List<category.Data>?>> getCarSubCategory() async {
    try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'car-subcategory', query: body)
          .then((value) {
        if (value.statusCode == 200) {
          if (CarCategory.fromJson(value.data).data != null) {
            return Right(CarCategory.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Car Category");
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
  Future<Either<String, List<category.Data>?>> getCarModel() async {
    try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'car-model', query: body)
          .then((value) {
        if (value.statusCode == 200) {
          if (CarCategory.fromJson(value.data).data != null) {
            return Right(CarCategory.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Car Model");
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
  Future<Either<String, List<category.Data>?>> getColor() async {
    try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'color', query: body).then((value) {
        if (value.statusCode == 200) {
          if (CarCategory.fromJson(value.data).data != null) {
            return Right(CarCategory.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Color");
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
  Future<Either<String, Data?>> getCar() async{
    // try {
      var body = {
        "limit": 99999,
      };

      return await DioHelper.getData(url: 'car', query: body).then((value) {
        if (value.statusCode == 200) {
          return Right(MyCarModel.fromJson(value.data!).data!.first);
        } else {
          return Left(serverFailureMessage);
        }
      });
    // } catch (error) {
    //   return Left(handleError(error));
    // }
  }

  @override
  Future<Either<String, CarRegisterationModel?>> carEdit(FormData data,String id) async{
    try {
      return await DioHelper.putData(
          url: 'car/$id',
          data: data,
          token: getIt<SharedPreferences>().getString("token"))
          .then((value) {
        if (value.statusCode == 200) {
          print(
              "carEdit*****************${CarRegisterationModel.fromJson(value.data!)}");

          return Right(CarRegisterationModel.fromJson(value.data!));
        } else {
          print(
              "carEdit*****************error");

          return Left(serverFailureMessage);
        }
      });
    } catch (error) {
      print("carEdit*****************error catch");
    return Left(handleError(error));
    }
  }

}
