import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/packages/PackagesModel.dart';
import 'package:getn_driver/domain/repository/PackagesRepository.dart';

class GetPackagesUseCase {
  final PackagesRepository packagesRepository;

  GetPackagesUseCase(this.packagesRepository);

  Future<Either<String, PackagesModel?>> execute(
      int index, String carCategory) {
    return packagesRepository.getPackages(index, carCategory);
  }
}
