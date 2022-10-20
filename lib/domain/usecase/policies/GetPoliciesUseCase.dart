import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/policies/PoliciesModel.dart';
import 'package:getn_driver/domain/repository/PoliciesRepository.dart';

class GetPoliciesUseCase {
  final PoliciesRepository policiesRepository;

  GetPoliciesUseCase(this.policiesRepository);

  Future<Either<String, PoliciesModel?>> execute(String title) {
    return policiesRepository.getPolicies(title);
  }
}
