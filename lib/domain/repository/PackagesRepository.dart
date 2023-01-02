import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/packages/PackagesModel.dart';

abstract class PackagesRepository {
  Future<Either<String, PackagesModel?>> getPackages(
      int index, String carCategory);
}
