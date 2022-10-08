import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';
import 'package:getn_driver/domain/repository/RequestRepository.dart';

class PutRequestDetailsUseCase {
  final RequestDetailsRepository requestDetailsRepository;

  PutRequestDetailsUseCase(this.requestDetailsRepository);

  Future<Either<String, DataRequest?>> execute(String id, String type, String comment) {
    return requestDetailsRepository.putRequest(id, type, comment);
  }
}
