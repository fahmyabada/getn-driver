import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/policies/PoliciesModel.dart';
import 'package:getn_driver/data/repository/policies/PoliciesRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/PoliciesRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class PoliciesRepositoryImpl extends PoliciesRepository {
  final PoliciesRemoteDataSource policiesRemoteDataSource;
  final NetworkInfo networkInfo;

  PoliciesRepositoryImpl(this.policiesRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, PoliciesModel?>> getPolicies(String title) async {
    String body = "";
    print("object111*************$title");
    if (title == LanguageCubit.get(navigatorKey.currentContext).getTexts('Terms&Condition')) {
      body = "terms_&_conditions";
    }else if (title == LanguageCubit.get(navigatorKey.currentContext).getTexts('PrivacyPolicy')) {
      body = "privacy_policy";
    }else if (title == LanguageCubit.get(navigatorKey.currentContext).getTexts('AboutUs')) {
      body = "about_us";
    }else if (title == LanguageCubit.get(navigatorKey.currentContext).getTexts('ContactUs')) {
      body = "contact_us";
    }else if (title == LanguageCubit.get(navigatorKey.currentContext).getTexts('FAQs')) {
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
