import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/signModel/Country.dart';
import 'package:getn_driver/data/repository/editProfile/EditProfileRemoteDataSource.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';
import 'package:getn_driver/main.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';

class EditProfileRepositoryImpl extends EditProfileRepository {
  final EditProfileRemoteDataSource editProfileRemoteDataSource;
  final NetworkInfo networkInfo;

  EditProfileRepositoryImpl(this.editProfileRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, EditProfileModel?>> getProfileDetails() async {
    if (await networkInfo.isConnected) {
      return await editProfileRemoteDataSource
          .getProfileDetails()
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }

  @override
  Future<Either<String, List<Country>?>> getArea(
      String countryId, String cityId) async {
    if (await networkInfo.isConnected) {
      return await editProfileRemoteDataSource
          .getArea(countryId, cityId)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }

  @override
  Future<Either<String, List<Country>?>> getCities(String countryId) async {
    if (await networkInfo.isConnected) {
      return await editProfileRemoteDataSource
          .getCities(countryId)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }

  @override
  Future<Either<String, List<Country>?>> getCountries() async {
    if (await networkInfo.isConnected) {
      return await editProfileRemoteDataSource.getCountries().then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }

  @override
  Future<Either<String, EditProfileModel>> editProfileDetails(FormData data) async {
    if (await networkInfo.isConnected) {
      return await editProfileRemoteDataSource
          .editProfileDetails(data)
          .then((value) {
        return value.fold((failure) {
          return Left(failure.toString());
        }, (data) {
          return Right(data);
        });
      });
    } else {
      return Left(LanguageCubit.get(navigatorKey.currentContext).getTexts('networkFailureMessage').toString());
    }
  }
}
