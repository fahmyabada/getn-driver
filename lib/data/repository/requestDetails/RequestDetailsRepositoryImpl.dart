import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/requestDetails/RequestDetails.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/data/repository/requestDetails/RequestDetailsRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';

class RequestDetailsRepositoryImpl extends RequestDetailsRepository {
  final RequestDetailsRemoteDataSource requestDetailsRemoteDataSource;
  final NetworkInfo networkInfo;

  RequestDetailsRepositoryImpl(
      this.requestDetailsRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, RequestDetails?>> getRequestDetails(String id) async {
    if (await networkInfo.isConnected) {
      return await requestDetailsRemoteDataSource
          .getRequestDetails(id)
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
  Future<Either<String, Trips?>> getTripsRequestDetails(
      Map<String, dynamic> body) async {
    if (await networkInfo.isConnected) {
      return await requestDetailsRemoteDataSource
          .getTripsRequestDetails(body)
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
}
