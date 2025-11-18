
import '../models/classification.dart';
import 'classifications_state.dart';

ClassificationsState? classificationsStateFromJson(Map<String, dynamic> json) {
  return ClassificationsState(
      List<Classification>.from(json['classifications']?.map((b) => classificationFromJson(b)) ?? []),
      json['lastUpdate']);
}

@override
Map<String, dynamic>? classificationsStateToJson(ClassificationsState state) {
  return {
    'classifications': state.classifications.map((s) => classificationToJson(s)).toList(),
  };
}

Map<String, dynamic>? classificationToJson(Classification classification) {
  return {
    'id': classification.id,
    'name': classification.name,
  };
}

Classification classificationFromJson(Map<String, dynamic> json) {
  return Classification(
    json['id'],
    json['name'],
  );
}
