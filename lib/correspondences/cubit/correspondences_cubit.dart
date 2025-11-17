// lib/cubits/correspondences/correspondences_cubit.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../models/correspondence.dart';
import '../models/correspondence_request.dart';
import '../models/get_correspondences_filter_model.dart';
import '../service/correspondence_service.dart';
import 'correspondences_state.dart';
import 'correspondences_mapper.dart';

class CorrespondencesCubit extends HydratedCubit<CorrespondencesState> {
  final CorrespondenceService service;

  CorrespondencesCubit(this.service) : super(CorrespondencesState.initial());

  Future<void> loadCorrespondences(GetCorrespondencesFilterModel filter) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true));

    try {
      final correspondences = await service.searchCorrespondences(filter);
      correspondences.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(state.copyWith(correspondences: correspondences, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addCorrespondence(CorrespondenceRequest request) async {
    try {
      final newId = await service.createCorrespondence(request);
      final newCorrespondence = await service.getCorrespondenceById(newId);

      final updatedList = List<Correspondence>.from(state.correspondences)
        ..insert(0, newCorrespondence); // Insert at the top

      emit(state.copyWith(correspondences: updatedList));
    } catch (e) {
      print('Error adding correspondence: $e');
    }
  }

  /// Updates an existing correspondence in the list.
  Future<void> updateCorrespondence(
    String id,
    CorrespondenceRequest request,
  ) async {
    try {
      await service.updateCorrespondence(id, request);
      final updatedCorrespondence = await service.getCorrespondenceById(id);
      final updatedList = state.correspondences.map((c) {
        return c.id == id ? updatedCorrespondence : c;
      }).toList();

      emit(state.copyWith(correspondences: updatedList));
    } catch (e) {
      print('Error updating correspondence: $e');
    }
  }

  /// Deletes a correspondence from the list by its ID.
  Future<void> deleteCorrespondence(String id) async {
    try {
      // 1. Send the delete request
      await service.deleteCorrespondence(id);

      // 2. Remove from state list without reloading
      final updatedList = state.correspondences
          .where((c) => c.id != id)
          .toList();

      emit(state.copyWith(correspondences: updatedList));
    } catch (e) {
      print('Error deleting correspondence: $e');
    }
  }

  /// Closes a correspondence and updates it in the list.
  Future<void> closeCorrespondence(String id) async {
    try {
      // 1. Send the close request
      await service.closeCorrespondence(id);

      // 2. Fetch the updated object (isClosed flag is now true)
      final updatedCorrespondence = await service.getCorrespondenceById(id);

      // 3. Find and replace in state list
      final updatedList = state.correspondences.map((c) {
        return c.id == id ? updatedCorrespondence : c;
      }).toList();

      emit(state.copyWith(correspondences: updatedList));
    } catch (e) {
      print('Error closing correspondence: $e');
    }
  }

  @override
  CorrespondencesState? fromJson(Map<String, dynamic> json) {
    return correspondencesStateFromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(CorrespondencesState state) {
    return correspondencesStateToJson(state);
  }
}
