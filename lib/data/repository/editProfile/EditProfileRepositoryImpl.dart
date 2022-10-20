import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/repository/editProfile/EditProfileRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/EditProfileRepository.dart';

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
      return Left(networkFailureMessage);
    }
  }

  @override
  Future<Either<String, List<Data>?>> getArea(
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
      return Left(networkFailureMessage);
    }
  }

  @override
  Future<Either<String, List<Data>?>> getCities(String countryId) async {
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
      return Left(networkFailureMessage);
    }
  }

  @override
  Future<Either<String, List<Data>?>> getCountries() async {
    if (await networkInfo.isConnected) {
      return await editProfileRemoteDataSource.getCountries().then((value) {
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
