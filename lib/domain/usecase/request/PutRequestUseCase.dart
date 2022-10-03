import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';

class PutRequestUseCase {
  final RequestRepository requestRepository;

  PutRequestUseCase(this.requestRepository);

  Future<Either<String, DataRequest?>> execute(String id, String type) {
    return requestRepository.putRequest(id, type);
  }
}
