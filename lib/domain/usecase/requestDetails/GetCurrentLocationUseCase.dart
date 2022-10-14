import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getn_driver/domain/repository/RequestDetailsRepository.dart';

class GetCurrentLocationUseCase {
  final RequestDetailsRepository requestDetailsRepository;

  GetCurrentLocationUseCase(this.requestDetailsRepository);

  Future<Either<String, Position>> execute() {
    return requestDetailsRepository.getCurrentLocation();
  }
}
