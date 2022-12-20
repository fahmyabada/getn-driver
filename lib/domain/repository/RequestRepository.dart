import 'package:dartz/dartz.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/data/model/request/DataRequest.dart';
import 'package:getn_driver/data/model/request/Request.dart';

abstract class RequestRepository {
  Future<Either<String, Request?>> getRequest(Map<String, dynamic> body);
  Future<Either<String, DataRequest?>> putRequest(String id, String type, String comment);
  Future<Either<String, EditProfileModel?>> getProfileDetails();
  Future<Either<String, String?>> signOut();
}
