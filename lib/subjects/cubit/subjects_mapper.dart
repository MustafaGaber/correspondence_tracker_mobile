
import '../models/subject.dart';
import 'subjects_state.dart';

SubjectsState? subjectsStateFromJson(Map<String, dynamic> json) {
  return SubjectsState(
      List<Subject>.from(json['subjects']?.map((b) => subjectFromJson(b)) ?? []),
      json['lastUpdate']);
}

@override
Map<String, dynamic>? subjectsStateToJson(SubjectsState state) {
  return {
    'subjects': state.subjects.map((s) => subjectToJson(s)).toList(),
  };
}

Map<String, dynamic>? subjectToJson(Subject subject) {
  return {
    'id': subject.id,
    'name': subject.name,
  };
}

Subject subjectFromJson(Map<String, dynamic> json) {
  return Subject(
    json['id'],
    json['name'],
  );
}
