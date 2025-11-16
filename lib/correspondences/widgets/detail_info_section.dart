import 'package:correspondence_tracker/shared/models/enums.dart';
import 'package:flutter/material.dart';

import '../models/correspondence_with_follow_ups.dart';

class DetailInfoSection extends StatelessWidget {
  final CorrespondenceWithFollowUps correspondence;
  
  const DetailInfoSection({super.key, required this.correspondence});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.5,
          children: [
            _InfoTile(
              label: 'الرقم',
              value: correspondence.direction == CorrespondenceDirection.incoming
                  ? correspondence.incomingNumber
                  : correspondence.outgoingNumber ?? '-',
              icon: Icons.numbers,
            ),
            _InfoTile(
              label: 'النوع',
              value: correspondence.direction == CorrespondenceDirection.incoming
                  ? 'وارد'
                  : 'صادر',
              icon: Icons.swap_horiz,
              color: correspondence.direction == CorrespondenceDirection.incoming
                  ? Colors.green.shade700
                  : Colors.blue.shade700,
            ),
            _InfoTile(
              label: 'التاريخ',
              value: correspondence.incomingDate?.toString() ??
                  correspondence.outgoingDate?.toString() ??
                  '-',
              icon: Icons.calendar_today,
            ),
            _InfoTile(
              label: 'الأهمية',
              value: _getPriorityLabel(correspondence.priorityLevel),
              icon: Icons.priority_high,
              color: _getPriorityColor(correspondence.priorityLevel),
            ),
            _InfoTile(
              label: 'الجهة المرسلة/المستقبلة',
              value: correspondence.correspondent?.name ?? '-',
              icon: Icons.business,
            ),
            _InfoTile(
              label: 'القسم المسؤول',
              value: correspondence.department?.name ?? '-',
              icon: Icons.apartment,
            ),
            _InfoTile(
              label: 'متابع الخطاب',
              value: correspondence.followUpUser?.name ?? '-',
              icon: Icons.person_search,
            ),
            _InfoTile(
              label: 'حالة الخطاب',
              value: correspondence.isClosed ? 'مغلق' : 'مفتوح',
              icon: correspondence.isClosed ? Icons.lock : Icons.lock_open,
              color: correspondence.isClosed ? Colors.grey : Colors.red,
            ),
            // Tags/Classifications
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _ClassificationTags(
                classifications: correspondence.classifications.map((c) => c.name).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPriorityLabel(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.high: return 'عالية';
      case PriorityLevel.medium: return 'متوسطة';
      case PriorityLevel.normal: return 'عادية';
    }
  }
  
  Color _getPriorityColor(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.high: return Colors.red;
      case PriorityLevel.medium: return Colors.orange;
      case PriorityLevel.normal: return Colors.blue;
    }
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayColor = color ?? theme.colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: displayColor),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClassificationTags extends StatelessWidget {
  final List<String> classifications;
  const _ClassificationTags({required this.classifications});

  @override
  Widget build(BuildContext context) {
    if (classifications.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Text(
          'التصنيفات:',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        ...classifications.map(
          (tag) => Chip(
            label: Text(tag),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }
}