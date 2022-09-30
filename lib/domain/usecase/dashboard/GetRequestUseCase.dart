import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/domain/repository/DashBoardRepository.dart';

class GetRequestUseCase {
  final DashBoardRepository dashBoardRepository;

  GetRequestUseCase(this.dashBoardRepository);

  Future<Either<String, Request?>> execute(Map<String, dynamic> body) {
    return dashBoardRepository.getRequestCurrent(body);
  }
}
