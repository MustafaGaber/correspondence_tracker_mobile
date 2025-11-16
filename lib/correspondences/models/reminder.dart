import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String id;
  final DateTime remindTime;
  final String? message;
  final bool sendEmailMessage;
  final bool isCompleted;
  final bool isDismissed;

  const Reminder({
    required this.id,
    required this.remindTime,
    this.message,
    required this.sendEmailMessage,
    this.isCompleted = false,
    this.isDismissed = false,
  });

  @override
  List<Object?> get props => [
        id,
        remindTime,
        message,
        sendEmailMessage,
        isCompleted,
        isDismissed,
      ];
}