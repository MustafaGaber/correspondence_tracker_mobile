import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../service/subjects_service.dart';
import 'subjects_mapper.dart';
import 'subjects_state.dart';

class SubjectsCubit extends HydratedCubit<SubjectsState> {
  final SubjectsService service;
  SubjectsCubit(this.service)
    : super(SubjectsState([], true)) {
    service.getSubjects().then((subjects) {
      emit(SubjectsState(subjects, false));
    });
  }

  @override
  SubjectsState? fromJson(Map<String, dynamic> json) {
    return subjectsStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SubjectsState state) {
    return subjectsStateToJson(state);
  }
}
