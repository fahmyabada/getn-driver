import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/trips/Trips.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';

class GetTripsRequestDetailsUseCase {
  final RequestDetailsRepository requestDetailsRepository;

  GetTripsRequestDetailsUseCase(this.requestDetailsRepository);

  Future<Either<String, Trips?>> execute(Map<String, dynamic> body) {
    return requestDetailsRepository.getTripsRequestDetails(body);
  }
}
