import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/DeleteAccountModel.dart';

abstract class SettingRepository {
  Future<Either<String, DeleteAccountModel?>> deleteAccount(String message);
}
