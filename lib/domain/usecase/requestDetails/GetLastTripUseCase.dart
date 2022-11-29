import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/request/Request.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';

class GetLastTripsUseCase {
  final RequestDetailsRepository requestDetailsRepository;

  GetLastTripsUseCase(this.requestDetailsRepository);

  Future<Either<String, Request?>> execute(String idRequest) {
    return requestDetailsRepository.getLastTrip(idRequest);
  }
}
