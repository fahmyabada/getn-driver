import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/requestDetails/RequestDetails.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';

class GetRequestDetailsUseCase {
  final RequestDetailsRepository requestDetailsRepository;

  GetRequestDetailsUseCase(this.requestDetailsRepository);

  Future<Either<String, RequestDetails?>> execute(String id) {
    return requestDetailsRepository.getRequestDetails(id);
  }
}
