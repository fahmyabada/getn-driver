import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/Request.dart';

abstract class RequestRepository {
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body);
}
