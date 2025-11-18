import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../service/departments_service.dart';
import 'departments_mapper.dart';
import 'departments_state.dart';

class DepartmentsCubit extends HydratedCubit<DepartmentsState> {
  final DepartmentsService service;
  DepartmentsCubit(this.service)
    : super(DepartmentsState([], true)) {
    service.getDepartments().then((departments) {
      emit(DepartmentsState(departments, false));
    });
  }

  @override
  DepartmentsState? fromJson(Map<String, dynamic> json) {
    return departmentsStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(DepartmentsState state) {
    return departmentsStateToJson(state);
  }
}
