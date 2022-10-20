import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/data/model/policies/PoliciesModel.dart';
import 'package:getn_driver/domain/usecase/policies/GetPoliciesUseCase.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';

part 'policies_state.dart';

class PoliciesCubit extends Cubit<PoliciesState> {
  PoliciesCubit() : super(PoliciesInitial());

  static PoliciesCubit get(context) => BlocProvider.of(context);

  var getPoliciesUseCase = getIt<GetPoliciesUseCase>();

  String? content;

  void getPolicies(String title) async {
    emit(PoliciesLoading());
    getPoliciesUseCase.execute(title).then((value) {
      emit(eitherLoadedOrErrorStatePolicies(value));
    });
  }

  PoliciesState eitherLoadedOrErrorStatePolicies(
      Either<String, PoliciesModel?> data) {
    return data.fold((failure1) {
      print("PoliciesErrorState*********** $failure1");
      return PoliciesErrorState(failure1);
    }, (data) {
      content = data!.content?.en;
      print("PoliciesSuccessState*********** $content");

      return PoliciesSuccessState(data);
    });
  }

}
