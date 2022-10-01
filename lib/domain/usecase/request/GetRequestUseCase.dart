import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';

class GetRequestUseCase {
  final RequestRepository requestRepository;

  GetRequestUseCase(this.requestRepository);

  Future<Either<String, Request?>> execute(Map<String, dynamic> body) {
    return requestRepository.getRequest(body);
  }
}
