import 'package:equatable/equatable.dart';

import '../../shared/models/date_only.dart';

class FollowUp extends Equatable {
  final String id;
  final String? details;
  final DateOnly date;

  const FollowUp({
    required this.id,
    this.details,
    required this.date,
  });

  @override
  List<Object?> get props => [id, details, date];
}