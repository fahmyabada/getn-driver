import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/repository/request/RequestRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestRepositoryImpl extends RequestRepository {
  final RequestRemoteDataSource requestRemoteDataSource;
  final NetworkInfo networkInfo;

  RequestRepositoryImpl(this.requestRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      return await requestRemoteDataSource.getRequest(body).then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, DataRequest?>> putRequest(
      String id, String type, String comment) async {
    if (await networkInfo.isConnected) {
      return await requestRemoteDataSource
          .putRequest(id, type, comment)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, EditProfileModel?>> getProfileDetails() async {
    if (await networkInfo.isConnected) {
      return await requestRemoteDataSource.getProfile().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) async {
          if (data!.fcmToken != null &&
              data.fcmToken !=
                  getIt<SharedPreferences>().getString("fcmToken").toString()) {
            var formData = FormData.fromMap({
              'fcmToken': getIt<SharedPreferences>().getString("fcmToken"),
            });
            await requestRemoteDataSource.editInformationUser(formData);
          }
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }

  @override
  Future<Either<String, String?>> signOut() async {
    if (await networkInfo.isConnected) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      FirebaseAuth.instance.signOut().then((value) => messaging.deleteToken());
      return const Right('success signOut');
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext)
          .getTexts('networkFailureMessage')
          .toString());
    }
  }
}
