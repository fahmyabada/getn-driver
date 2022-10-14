import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/trips/Data.dart';
import 'package:getn_driver/domain/repository/AddTripRepository.dart';

class CreateTripUseCase {
  final AddTripRepository addTripRepository;

  CreateTripUseCase(this.addTripRepository);

  Future<Either<String, Data?>> execute(Data data) {
    return addTripRepository.createTrip(data);
  }
}
