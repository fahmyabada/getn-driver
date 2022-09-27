import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/network_info.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/repository/dashBoard/DashBoardRemoteDataSource.dart';
import 'package:getn_driver/data/utils/constant.dart';
import 'package:getn_driver/domain/repository/DashBoardRepository.dart';

class DashBoardRepositoryImpl extends DashBoardRepository {
  final DashBoardRemoteDataSource dashBoardRemoteDataSource;
  final NetworkInfo networkInfo;

  DashBoardRepositoryImpl(this.dashBoardRemoteDataSource, this.networkInfo);

  @override
  Future<Either<String, List<DataRole>?>> getRequest() async{
    if (await networkInfo.isConnected) {
      return await dashBoardRemoteDataSource.getRequest().then((value) {
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
