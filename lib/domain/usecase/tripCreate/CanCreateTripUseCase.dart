import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/CanCreateTrip/CanCreateTrip.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/domain/repository/TripCreateRepository.dart';

class CanCreateTripUseCase {
  final TripCreateRepository addTripRepository;

  CanCreateTripUseCase(this.addTripRepository);

  Future<Either<String, CanCreateTrip?>> execute(CreateTripModel data) {
    return addTripRepository.canCreateTrip(data);
  }
}
