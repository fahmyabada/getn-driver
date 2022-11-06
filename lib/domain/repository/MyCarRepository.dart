import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/model/carCategory/Data.dart' as category;
import 'package:getn_driver/data/model/carRegisteration/CarRegisterationModel.dart';
import '../../data/model/myCar/Data.dart';

abstract class MyCarRepository {
  Future<Either<String, Data?>> getCar();

  Future<Either<String, List<category.Data>?>> getCarSubCategory();

  Future<Either<String, List<category.Data>?>> getCarModel();

  Future<Either<String, List<category.Data>?>> getColor();

  Future<Either<String, CarRegisterationModel?>> carEdit(FormData data,String id);

}
