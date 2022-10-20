import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/policies/PoliciesModel.dart';
import 'package:getn_driver/data/repository/policies/PoliciesRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/PoliciesRepository.dart';

class PoliciesRepositoryImpl extends PoliciesRepository {
  final PoliciesRemoteDataSource policiesRemoteDataSource;
  final NetworkInfo networkInfo;

  PoliciesRepositoryImpl(this.policiesRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, PoliciesModel?>> getPolicies(String title) async {
    String body = "";
    if (title == "Terms & Conditions") {
      body = "terms_&_conditions";
    }else if (title == "Privacy Policy") {
      body = "privacy_policy";
    }else if (title == "About Us") {
      body = "about_us";
    }else if (title == "Contact Us") {
      body = "contact_us";
    }else if (title == "FAQs") {
      body = "faqs";
    }
    if (await networkInfo.isConnected) {
      return await policiesRemoteDataSource.getPolicies(body).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(networkFailureMessage);
    }
  }
}
