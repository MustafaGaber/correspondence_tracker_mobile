// File: lib/correspondences/models/correspondence_request.dart

import 'package:correspondence_tracker/shared/models/date_only.dart';
import 'package:correspondence_tracker/shared/models/enums.dart';
import 'package:equatable/equatable.dart';

/// Data Transfer Object for creating or updating reminders.
/// Based on `ReminderDto` in models.ts
class ReminderDto extends Equatable {
  final String? id;
  final DateTime remindTime;
  final String? message;
  final bool sendEmailMessage;

  const ReminderDto({
    this.id,
    required this.remindTime,
    this.message,
    required this.sendEmailMessage,
  });

  @override
  List<Object?> get props => [id, remindTime, message, sendEmailMessage];
  
  // You would typically add toJson/fromJson methods here for API calls
}

/// Data Transfer Object for creating or updating a correspondence.
/// Based on `CorrespondenceRequest` in models.ts
class CorrespondenceRequest extends Equatable {
  final String? id;
  // Note: The file is handled separately in Flutter, 
  // typically via a multipart request, not in the main request body.
  final String? incomingNumber;
  final DateOnly? incomingDate;
  final String? senderId;
  final String? outgoingNumber;
  final DateOnly? outgoingDate;
  final String? departmentId;
  final String? content;
  final String? summary;
  final String? followUpUserId;
  final String? responsibleUserId;
  final String? subjectId;
  final String? notes;
  final bool isClosed;
  final CorrespondenceDirection? direction;
  final PriorityLevel? priorityLevel;
  final List<String>? classificationIds;
  final List<ReminderDto>? reminders;

  const CorrespondenceRequest({
    this.id,
    this.incomingNumber,
    this.incomingDate,
    this.senderId,
    this.outgoingNumber,
    this.outgoingDate,
    this.departmentId,
    this.content,
    this.summary,
    this.followUpUserId,
    this.responsibleUserId,
    this.subjectId,
    this.notes,
    required this.isClosed,
    this.direction,
    this.priorityLevel,
    this.classificationIds,
    this.reminders,
  });

  @override
  List<Object?> get props => [
        id,
        incomingNumber,
        incomingDate,
        senderId,
        outgoingNumber,
        outgoingDate,
        departmentId,
        content,
        summary,
        followUpUserId,
        responsibleUserId,
        subjectId,
        notes,
        isClosed,
        direction,
        priorityLevel,
        classificationIds,
        reminders,
      ];
}

/*import 'package:correspondence_tracker/shared/models/date_only.dart';
import 'package:equatable/equatable.dart';
import 'reminder_dto.dart';

class CorrespondenceRequest extends Equatable {
  final String? id;
  final String? filePath; // Changed from File
  final String? fileName; // Added helper for multipart
  final String? incomingNumber;
  final DateOnly? incomingDate;
  final String? senderId;
  final String? outgoingNumber;
  final DateOnly? outgoingDate;
  final String? departmentId;
  final String? content;
  final String? summary;
  final String? followUpUserId;
  final String? responsibleUserId;
  final String? subjectId;
  final String? notes;
  final bool isClosed;
  final int? direction;
  final int? priorityLevel;
  final List<String>? classificationIds;
  final List<ReminderDto>? reminders;

  const CorrespondenceRequest({
    this.id,
    this.filePath,
    this.fileName,
    this.incomingNumber,
    this.incomingDate,
    this.senderId,
    this.outgoingNumber,
    this.outgoingDate,
    this.departmentId,
    this.content,
    this.summary,
    this.followUpUserId,
    this.responsibleUserId,
    this.subjectId,
    this.notes,
    required this.isClosed,
    this.direction,
    this.priorityLevel,
    this.classificationIds,
    this.reminders,
  });

  @override
  List<Object?> get props => [
        id,
        filePath,
        fileName,
        incomingNumber,
        incomingDate,
        senderId,
        outgoingNumber,
        outgoingDate,
        departmentId,
        content,
        summary,
        followUpUserId,
        responsibleUserId,
        subjectId,
        notes,
        isClosed,
        direction,
        priorityLevel,
        classificationIds,
        reminders,
      ];
}*/