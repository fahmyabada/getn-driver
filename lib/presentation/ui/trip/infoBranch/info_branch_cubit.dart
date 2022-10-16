import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'info_branch_state.dart';

class InfoBranchCubit extends Cubit<InfoBranchState> {
  InfoBranchCubit() : super(InfoBranchInitial());
}
