import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../models/follow_up.dart';

class FollowUpListView extends StatelessWidget {
  final List<FollowUp> followUps;

  const FollowUpListView({super.key, required this.followUps});

  @override
  Widget build(BuildContext context) {
    if (followUps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'لا توجد متابعات لهذا الخطاب.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
      );
    }
    
    // Sort follow-ups by date (oldest first for chronological timeline)
    final sortedFollowUps = List<FollowUp>.from(followUps)
      ..sort((a, b) => a.date.compareTo(b.date));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedFollowUps.length,
      itemBuilder: (context, index) {
        final item = sortedFollowUps[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline Indicator
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index < sortedFollowUps.length - 1)
                    Container(
                      width: 2,
                      height: 50, // Fixed height for vertical line segment
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Content Card
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intl.DateFormat('yyyy/MM/dd').format(item.date.dateTime),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.details ?? 'لا توجد تفاصيل متابعة.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}