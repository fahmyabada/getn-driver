import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';

abstract class RequestDetailsRepository {
  Future<Either<String, DataRequest?>> getRequestDetails(String id);
}
