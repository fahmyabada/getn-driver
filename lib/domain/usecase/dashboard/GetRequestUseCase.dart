import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/country/Data.dart';
import 'package:getn_driver/data/model/role/DataRole.dart';
import 'package:getn_driver/domain/repository/DashBoardRepository.dart';
import 'package:getn_driver/domain/repository/SignInRepository.dart';

class GetRequestUseCase {
  final DashBoardRepository dashBoardRepository;

  GetRequestUseCase(this.dashBoardRepository);

  Future<Either<String, List<DataRole>?>> execute() {
    return dashBoardRepository.getRequest();
  }
}
