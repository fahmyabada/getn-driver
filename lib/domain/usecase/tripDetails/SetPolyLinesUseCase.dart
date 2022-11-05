import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/api_result_model.dart';
import 'package:getn_driver/domain/repository/TripDetailsRepository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SetPolyLinesUseCase {
  final TripDetailsRepository tripDetailsRepository;

  SetPolyLinesUseCase(this.tripDetailsRepository);

  Future<Either<String, APIResultModel>> execute(LatLng l1, LatLng l2) {
    return tripDetailsRepository.setPolyLines(l1, l2);
  }
}
