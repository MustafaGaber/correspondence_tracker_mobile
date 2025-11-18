import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../service/correspondents_service.dart';
import 'correspondents_mapper.dart';
import 'correspondents_state.dart';

class CorrespondentsCubit extends HydratedCubit<CorrespondentsState> {
  final CorrespondentsService service;
  CorrespondentsCubit(this.service)
    : super(CorrespondentsState([], true)) {
    service.getCorrespondents().then((correspondents) {
      emit(CorrespondentsState(correspondents, false));
    });
  }

  @override
  CorrespondentsState? fromJson(Map<String, dynamic> json) {
    return correspondentsStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(CorrespondentsState state) {
    return correspondentsStateToJson(state);
  }
}
