import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../models/reminder.dart';

class ReminderListView extends StatelessWidget {
  final List<Reminder> reminders;

  const ReminderListView({super.key, required this.reminders});

  @override
  Widget build(BuildContext context) {
    if (reminders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'لا توجد تذكيرات مجدولة.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final item = reminders[index];
        final isCompleted = item.isCompleted || item.isDismissed;

        return ListTile(
          leading: Icon(
            isCompleted ? Icons.check_circle : Icons.alarm,
            color: isCompleted ? Colors.green : Theme.of(context).colorScheme.tertiary,
          ),
          title: Text(
            item.message ?? 'تذكير بدون رسالة',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? Theme.of(context).colorScheme.outline : null,
            ),
          ),
          subtitle: Text(
            'الوقت: ${intl.DateFormat('yyyy/MM/dd HH:mm').format(item.remindTime)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: item.sendEmailMessage
              ? Tooltip(
                  message: 'سيتم إرسال رسالة بريد إلكتروني',
                  child: Icon(Icons.email_outlined, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                )
              : null,
        );
      },
    );
  }
}