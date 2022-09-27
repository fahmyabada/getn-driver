import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';

abstract class DashBoardRepository {
  Future<Either<String, List<DataRole>?>> getRequest();
}
