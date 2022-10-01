import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';

class GetRequestDetailsUseCase {
  final RequestDetailsRepository requestDetailsRepository;

  GetRequestDetailsUseCase(this.requestDetailsRepository);

  Future<Either<String, DataRequest?>> execute(String id) {
    return requestDetailsRepository.getRequestDetails(id);
  }
}
