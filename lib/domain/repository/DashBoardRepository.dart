import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/Request.dart';

abstract class DashBoardRepository {
  Future<Either<String, Request?>> getRequestCurrent(Map<String, dynamic> body);
}
