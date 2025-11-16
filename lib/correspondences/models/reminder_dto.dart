import 'package:equatable/equatable.dart';

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
}