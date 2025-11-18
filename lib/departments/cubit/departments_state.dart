import 'package:equatable/equatable.dart';

import '../models/department.dart'; 

class DepartmentsState extends Equatable {
  final List<Department> departments;
  final bool isLoading;

  const DepartmentsState(
    this.departments,
    this.isLoading,
  );

  @override
  List<Object?> get props => [departments, isLoading];
}