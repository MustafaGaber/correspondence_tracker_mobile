
import '../models/department.dart';
import 'departments_state.dart';

DepartmentsState? departmentsStateFromJson(Map<String, dynamic> json) {
  return DepartmentsState(
      List<Department>.from(json['departments']?.map((b) => departmentFromJson(b)) ?? []),
      json['lastUpdate']);
}

@override
Map<String, dynamic>? departmentsStateToJson(DepartmentsState state) {
  return {
    'departments': state.departments.map((s) => departmentToJson(s)).toList(),
  };
}

Map<String, dynamic>? departmentToJson(Department department) {
  return {
    'id': department.id,
    'name': department.name,
  };
}

Department departmentFromJson(Map<String, dynamic> json) {
  return Department(
    json['id'],
    json['name'],
  );
}
