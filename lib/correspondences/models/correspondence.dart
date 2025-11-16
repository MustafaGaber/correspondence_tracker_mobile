import 'package:correspondence_tracker/correspondences/models/subject.dart';
import 'package:correspondence_tracker/correspondents/models/correspondent.dart';
import 'package:correspondence_tracker/shared/models/date_only.dart';
import 'package:correspondence_tracker/shared/models/enums.dart';
import 'package:correspondence_tracker/users/models/user.dart';
import 'package:equatable/equatable.dart';
import '../../classifications/models/classification.dart';
import '../../departments/models/department.dart';
import 'reminder.dart';

class Correspondence extends Equatable {
  final String id;
  final String? fileId;
  final String? extension;
  final CorrespondenceDirection direction;
  final PriorityLevel priorityLevel;
  final String incomingNumber;
  final DateOnly? incomingDate;
  final String? outgoingNumber;
  final DateOnly? outgoingDate;
  final Correspondent? correspondent;
  final Department? department;
  final String? content;
  final String? summary;
  final User? followUpUser;
  final User? responsibleUser;
  final bool isClosed;
  final String createdAt;
  final List<Classification> classifications;
  final Subject? subject;
  final String? notes;
  final List<Reminder> reminders;

  const Correspondence({
    required this.id,
    this.fileId,
    this.extension,
    required this.direction,
    required this.priorityLevel,
    required this.incomingNumber,
    this.incomingDate,
    this.outgoingNumber,
    this.outgoingDate,
    this.correspondent,
    this.department,
    this.content,
    this.summary,
    this.followUpUser,
    this.responsibleUser,
    required this.isClosed,
    required this.createdAt,
    this.classifications = const [],
    this.subject,
    this.notes,
    this.reminders = const [],
  });

  @override
  List<Object?> get props => [
        id,
        fileId,
        extension,
        direction,
        priorityLevel,
        incomingNumber,
        incomingDate,
        outgoingNumber,
        outgoingDate,
        correspondent,
        department,
        content,
        summary,
        followUpUser,
        responsibleUser,
        isClosed,
        createdAt,
        classifications,
        subject,
        notes,
        reminders,
      ];
}