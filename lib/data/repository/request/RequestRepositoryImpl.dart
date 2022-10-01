import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/data/repository/request/RequestRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';

class RequestRepositoryImpl extends RequestRepository {
  final RequestRemoteDataSource requestRemoteDataSource;
  final NetworkInfo networkInfo;

  RequestRepositoryImpl(this.requestRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body) async{
    if (await networkInfo.isConnected) {
      return await requestRemoteDataSource.getRequest(body).then((value) {
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
