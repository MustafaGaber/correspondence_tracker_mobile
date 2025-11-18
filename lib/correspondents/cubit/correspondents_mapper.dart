
import '../models/correspondent.dart';
import 'correspondents_state.dart';

CorrespondentsState? correspondentsStateFromJson(Map<String, dynamic> json) {
  return CorrespondentsState(
      List<Correspondent>.from(json['correspondents']?.map((b) => correspondentFromJson(b)) ?? []),
      json['lastUpdate']);
}

@override
Map<String, dynamic>? correspondentsStateToJson(CorrespondentsState state) {
  return {
    'correspondents': state.correspondents.map((s) => correspondentToJson(s)).toList(),
  };
}

Map<String, dynamic>? correspondentToJson(Correspondent correspondent) {
  return {
    'id': correspondent.id,
    'name': correspondent.name,
  };
}

Correspondent correspondentFromJson(Map<String, dynamic> json) {
  return Correspondent(
    json['id'],
    json['name'],
  );
}
