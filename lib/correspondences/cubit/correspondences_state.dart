import 'package:equatable/equatable.dart';

import '../models/correspondence.dart'; 

class CorrespondencesState extends Equatable {
  final List<Correspondence> correspondences;
  final bool isLoading;

  const CorrespondencesState({
    required this.correspondences,
    this.isLoading = false,
  });

  /// The initial state of the cubit.
  factory CorrespondencesState.initial() {
    return const CorrespondencesState(correspondences: [], isLoading: false);
  }

  /// Creates a copy of the state with optional new values.
  CorrespondencesState copyWith({
    List<Correspondence>? correspondences,
    bool? isLoading,
  }) {
    return CorrespondencesState(
      correspondences: correspondences ?? this.correspondences,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [correspondences, isLoading];
}