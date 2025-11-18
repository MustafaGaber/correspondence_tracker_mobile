import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/subjects_cubit.dart';
import '../cubit/subjects_state.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsCubit, SubjectsState>(
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) => Card(
            child: Text(state.subjects[index].name),
          ),
          itemCount: state.subjects.length,
        );
      },
    );
  }
}
