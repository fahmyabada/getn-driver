import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/editProfile/EditProfileModel.dart';
import 'package:getn_driver/domain/usecase/editProfile/GetProfileDetailsUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileInitial());

  static EditProfileCubit get(context) => BlocProvider.of(context);

  var getProfileDetailsUseCase = getIt<GetProfileDetailsUseCase>();

  EditProfileModel? profileDetails;

  void getProfileDetails() async {
    emit(EditProfileLoading());
    getProfileDetailsUseCase.execute().then((value) {
      emit(eitherLoadedOrErrorStateProfileDetails(value));
    });
  }

  EditProfileState eitherLoadedOrErrorStateProfileDetails(
      Either<String, EditProfileModel?> data) {
    return data.fold((failure1) {
      print("EditProfileErrorState*********** $failure1");
      return EditProfileErrorState(failure1);
    }, (data) {
      print("EditProfileSuccessState*********** $data");
      profileDetails = data;

      return EditProfileSuccessState(data);
    });
  }

}
