import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../service/classifications_service.dart';
import 'classifications_mapper.dart';
import 'classifications_state.dart';

class ClassificationsCubit extends HydratedCubit<ClassificationsState> {
  final ClassificationsService service;
  ClassificationsCubit(this.service)
    : super(ClassificationsState([], true)) {
    service.getClassifications().then((classifications) {
      emit(ClassificationsState(classifications, false));
    });
  }

  @override
  ClassificationsState? fromJson(Map<String, dynamic> json) {
    return classificationsStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ClassificationsState state) {
    return classificationsStateToJson(state);
  }
}
