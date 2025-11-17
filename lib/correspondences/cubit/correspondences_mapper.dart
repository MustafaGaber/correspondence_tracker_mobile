import 'correspondences_state.dart';

/// Deserializes the JSON map into a [CorrespondencesState].
CorrespondencesState? correspondencesStateFromJson(Map<String, dynamic> json) {
  try {
    return null;
   /* return CorrespondencesState(
      correspondences: List<Correspondence>.from(
        json['correspondences']
          // Assumes Correspondence.fromMap exists
          ?.map((c) => Correspondence.fromMap(c as Map<String, dynamic>)) ?? [],
      ),
      isLoading: json['isLoading'] ?? false,
    );*/
  } catch (e) {
    // Return null or initial state if hydration fails
    return null;
  }
}

/// Serializes the [CorrespondencesState] into a JSON map.
Map<String, dynamic>? correspondencesStateToJson(CorrespondencesState state) {
  return {
    'correspondences': [], //state.correspondences.map((c) => c.toMap()) .toList(),
    'isLoading': state.isLoading,
  };
}

