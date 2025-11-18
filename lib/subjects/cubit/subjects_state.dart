import 'package:equatable/equatable.dart';

import '../models/subject.dart'; 

class SubjectsState extends Equatable {
  final List<Subject> subjects;
  final bool isLoading;

  const SubjectsState(
    this.subjects,
    this.isLoading,
  );

  @override
  List<Object?> get props => [subjects, isLoading];
}