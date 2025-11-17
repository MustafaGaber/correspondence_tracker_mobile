import 'package:flutter/material.dart';
import '../models/correspondence.dart';

class DetailInfoSection extends StatelessWidget {
  final Correspondence correspondence;

  const DetailInfoSection({super.key, required this.correspondence});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final classifications = correspondence.classifications
        .map((c) => c.name)
        .toList();

    final String date =
        correspondence.incomingDate?.toString() ??
        correspondence.outgoingDate?.toString() ??
        '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          correspondence.subject?.name ?? 'لا يوجد موضوع',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            _DetailRow(label: 'التاريخ', value: date),
            Spacer(),
            /*_StatusChip(
              label:
                  correspondence.direction == CorrespondenceDirection.incoming
                  ? 'وارد'
                  : 'صادر',
              color:
                  correspondence.direction == CorrespondenceDirection.incoming
                  ? Colors.green.shade700
                  : Colors.blue.shade700,
            ),*/
            /*_StatusChip(
              label: _getPriorityLabel(correspondence.priorityLevel),
              color: _getPriorityColor(correspondence.priorityLevel),
            ),*/
            _StatusChip(
              label: correspondence.isClosed ? 'مغلق' : 'مفتوح',
              color: correspondence.isClosed
                  ? Colors.grey.shade600
                  : Colors.red.shade700,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // 3. Details List (Handles long text)
        // This layout is very robust for variable length text.
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(
              label: 'الجهة المرسلة/المستقبلة',
              value: correspondence.correspondent?.name ?? '-',
            ),
            _DetailRow(
              label: 'القسم المسؤول',
              value: correspondence.department?.name ?? '-',
            ),
            _DetailRow(
              label: 'متابع الخطاب',
              value: correspondence.followUpUser?.name ?? '-',
            ),
          ],
        ),

        // 4. Classifications (Tags)
        if (classifications.isNotEmpty) ...[
          const Divider(height: 32.0),
          _ClassificationTags(classifications: classifications),
        ],
      ],
    );
  }

  /*String _getPriorityLabel(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.high:
        return 'عالية';
      case PriorityLevel.medium:
        return 'متوسطة';
      case PriorityLevel.normal:
        return 'عادية';
    }
  }*/

  /*Color _getPriorityColor(PriorityLevel p) {
    switch (p) {
      case PriorityLevel.high:
        return Colors.red.shade700;
      case PriorityLevel.medium:
        return Colors.orange.shade700;
      case PriorityLevel.normal:
        return Colors.blue.shade700;
    }
  }*/
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}

class _ClassificationTags extends StatelessWidget {
  final List<String> classifications;
  const _ClassificationTags({required this.classifications});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التصنيفات:',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: classifications
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
