import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/api/Dio_Helper.dart';
import 'package:getn_driver/data/model/country/CountryData.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/data/model/role/Role.dart';
import 'package:getn_driver/data/utils/constant.dart';

abstract class DashBoardRemoteDataSource {
  Future<Either<String, List<DataRole>?>> getRequest();
}

class DashBoardRemoteDataSourceImpl implements DashBoardRemoteDataSource {
  @override
  Future<Either<String, List<DataRole>?>> getRequest() async{
    try {
      var body = {"select": "title type", "app": "driver-app"};

      return await DioHelper.getData(url: 'role', query: body).then((value) {
        if (value.statusCode == 200) {
          if (Role.fromJson(value.data).data != null) {
            return Right(Role.fromJson(value.data!).data!);
          } else {
            return const Left("Not Found Roles");
          }
        } else {
          return Left(serverFailureMessage);
        }
      });
    } on Exception {
      return const Left("you have error when get Roles");
    }
  }
}
