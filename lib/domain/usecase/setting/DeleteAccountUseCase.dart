import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/DeleteAccountModel.dart';
import 'package:getn_driver/domain/repository/SettingRepository.dart';

class DeleteAccountUseCase {
  final SettingRepository settingRepository;

  DeleteAccountUseCase(this.settingRepository);

  Future<Either<String, DeleteAccountModel?>> execute(String message) {
    return settingRepository.deleteAccount(message);
  }
}
