import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/departments_cubit.dart';
import '../cubit/departments_state.dart';

class DepartmentsPage extends StatelessWidget {
  const DepartmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) => Card(
            child: Text(state.departments[index].name),
          ),
          itemCount: state.departments.length,
        );
      },
    );
  }
}
