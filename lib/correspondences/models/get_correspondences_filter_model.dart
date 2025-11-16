import 'package:correspondence_tracker/shared/models/date_only.dart';
import 'package:equatable/equatable.dart';

class GetCorrespondencesFilterModel extends Equatable {
  final String? searchTerm;
  final int? direction;
  final int? priorityLevel;
  final bool isClosed;
  final DateOnly? fromDate;
  final DateOnly? toDate;
  final int? pageNumber;
  final int? pageSize;

  const GetCorrespondencesFilterModel({
    this.searchTerm,
    this.direction,
    this.priorityLevel,
    required this.isClosed,
    this.fromDate,
    this.toDate,
    this.pageNumber,
    this.pageSize,
  });

  @override
  List<Object?> get props => [
        searchTerm,
        direction,
        priorityLevel,
        isClosed,
        fromDate,
        toDate,
        pageNumber,
        pageSize,
      ];

  /// Creates a map for the HTTP request, omitting null values.
  /// This replaces the 'prepareRequestPayload' logic.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'isClosed': isClosed,
    };

    if (searchTerm != null) map['searchTerm'] = searchTerm;
    if (direction != null) map['direction'] = direction;
    if (priorityLevel != null) map['priorityLevel'] = priorityLevel;
    if (fromDate != null) map['fromDate'] = fromDate.toString();
    if (toDate != null) map['toDate'] = toDate.toString();
    if (pageNumber != null) map['pageNumber'] = pageNumber;
    if (pageSize != null) map['pageSize'] = pageSize;

    return map;
  }

   GetCorrespondencesFilterModel copyWith({
    String? searchTerm,
    int? direction,
    int? priorityLevel,
    bool? isClosed,
    DateOnly? fromDate,
    DateOnly? toDate,
    int? pageNumber,
    int? pageSize,
  }) {
    return GetCorrespondencesFilterModel(
      searchTerm: searchTerm ?? this.searchTerm,
      direction: direction ?? this.direction,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      isClosed: isClosed ?? this.isClosed,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}