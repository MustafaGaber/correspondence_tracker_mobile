import 'package:correspondence_tracker/shared/models/date_only.dart';
import 'package:correspondence_tracker/shared/models/enums.dart';
import '../../classifications/models/classification.dart';
import '../../correspondents/models/correspondent.dart';
import '../../departments/models/department.dart';
import '../../users/models/user.dart';
import '../models/correspondence.dart';
import '../models/correspondence_with_follow_ups.dart';
import '../models/create_correspondence_from_image_response.dart';
import '../models/follow_up.dart';
import '../models/generate_subject_correspondence_response.dart';
import '../models/reminder.dart';
import '../models/subject.dart';

// Note: 'data' is expected to be a Map<String, dynamic>
// It's typed as 'dynamic' to match the TS 'any' type.

FollowUp followUpFromMap(dynamic data) {
  return FollowUp(
    id: data['id'],
    details: data['details'],
    date: DateOnly.fromString(data['date']),
  );
}

Reminder reminderFromMap(dynamic data) {
  return Reminder(
    id: data['id'],
    remindTime: DateTime.parse(data['remindTime']),
    message: data['message'],
    sendEmailMessage: data['sendEmailMessage'],
    isCompleted: data['isCompleted'] ?? false,
    isDismissed: data['isDismissed'] ?? false,
  );
}

Correspondence correspondenceFromMap(dynamic map) {
  return Correspondence(
    id: map['id'],
    direction: CorrespondenceDirectionInt.fromValue(map['direction']),
    priorityLevel: PriorityLevelInt.fromValue(map['priorityLevel']),
    incomingNumber: map['incomingNumber'] ?? '',
    incomingDate: map['incomingDate'] != null
        ? DateOnly.fromString(map['incomingDate'])
        : null,
    outgoingNumber: map['outgoingNumber'],
    outgoingDate: map['outgoingDate'] != null
        ? DateOnly.fromString(map['outgoingDate'])
        : null,
    correspondent: map['correspondent'] != null
        ? Correspondent(
            map['correspondent']['id'], map['correspondent']['name'])
        : null,
    department: map['department'] != null
        ? Department(map['department']['id'], map['department']['name'])
        : null,
    content: map['content'],
    summary: map['summary'],
    followUpUser: map['followUpUser'] != null
        ? User(map['followUpUser']['id'], map['followUpUser']['name'])
        : null,
    responsibleUser: map['responsibleUser'] != null
        ? User(map['responsibleUser']['id'], map['responsibleUser']['name'])
        : null,
    subject: map['subject'] != null
        ? Subject(map['subject']['id'], map['subject']['name'])
        : null,
    isClosed: map['isClosed'] ?? false,
    createdAt: map['createdAt'] ?? '',
    classifications: (map['classifications'] as List<dynamic>? ?? [])
        .map((c) => Classification(c['id'], c['name']))
        .toList(),
    fileId: map['fileId'],
    fileExtension: map['fileExtension'],
    notes: map['notes'],
    finalAction: map['finalAction'],
    reminders: (map['reminders'] as List<dynamic>? ?? [])
        .map((r) => reminderFromMap(r))
        .toList(),
  );
}

CorrespondenceWithFollowUps correspondenceWithFollowUpsFromMap(dynamic map) {
  final followUps = (map['followUps'] as List<dynamic>? ?? [])
      .map((fu) => followUpFromMap(fu))
      .toList();

  // Sort follow-ups as in the original service
  followUps.sort((a, b) => a.date.compareTo(b.date));

  // Get base correspondence data
  final base = correspondenceFromMap(map);

  return CorrespondenceWithFollowUps(
    followUps: followUps,
    id: base.id,
    direction: base.direction,
    priorityLevel: base.priorityLevel,
    incomingNumber: base.incomingNumber,
    incomingDate: base.incomingDate,
    outgoingNumber: base.outgoingNumber,
    outgoingDate: base.outgoingDate,
    correspondent: base.correspondent,
    department: base.department,
    content: base.content,
    summary: base.summary,
    followUpUser: base.followUpUser,
    responsibleUser: base.responsibleUser,
    isClosed: base.isClosed,
    createdAt: base.createdAt,
    classifications: base.classifications,
    fileId: base.fileId,
    fileExtension: base.fileExtension,
    notes: base.notes,
    reminders: base.reminders,
    subject: base.subject,
  );
}

CreateCorrespondenceFromImageResponse createFromImageResponseFromMap(
    dynamic map) {
  return CreateCorrespondenceFromImageResponse(
    id: map['id'],
    content: map['content'],
    summary: map['summary'],
    fileId: map['fileId'],
  );
}

GenerateSubjectCorrespondenceResponse generateReplyResponseFromMap(dynamic map) {
  return GenerateSubjectCorrespondenceResponse(map['generatedContent']);
}