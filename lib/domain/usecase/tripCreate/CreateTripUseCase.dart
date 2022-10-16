import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/CreateTripModel.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/repository/TripCreateRepository.dart';

class CreateTripUseCase {
  final TripCreateRepository addTripRepository;

  CreateTripUseCase(this.addTripRepository);

  Future<Either<String, Data?>> execute(CreateTripModel data) {
    return addTripRepository.createTrip(data);
  }
}
