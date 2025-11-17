
import 'correspondence.dart';
import 'follow_up.dart';

class CorrespondenceWithFollowUps extends Correspondence {
  final List<FollowUp> followUps;

  const CorrespondenceWithFollowUps({
    required this.followUps,
    // Props from base Correspondence class
    required super.id,
    super.fileId,
    super.fileExtension,
    required super.direction,
    required super.priorityLevel,
    required super.incomingNumber,
    super.incomingDate,
    super.outgoingNumber,
    super.outgoingDate,
    super.correspondent,
    super.department,
    super.content,
    super.summary,
    super.followUpUser,
    super.responsibleUser,
    required super.isClosed,
    required super.createdAt,
    super.classifications,
    super.subject,
    super.notes,
    super.reminders,
  });

  @override
  List<Object?> get props => [...super.props, followUps];
}