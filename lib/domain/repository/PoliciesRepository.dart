import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/policies/PoliciesModel.dart';

abstract class PoliciesRepository {
  Future<Either<String, PoliciesModel?>> getPolicies(String title);
}
