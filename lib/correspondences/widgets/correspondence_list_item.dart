import 'package:correspondence_tracker/shared/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../../shared/models/date_only.dart';
import '../models/correspondence.dart';

class CorrespondenceListItem extends StatelessWidget {
  final Correspondence item;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewFile;

  const CorrespondenceListItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onViewFile,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String number = item.direction == CorrespondenceDirection.incoming
        ? 'وارد${item.incomingNumber?.isEmpty ?? false ? '' : ' رقم ${item.incomingNumber}'}'
        : 'صادر${item.outgoingNumber?.isEmpty ?? false ? '' :  ' رقم ${item.outgoingNumber}'}';

    DateOnly? date = item.direction == CorrespondenceDirection.incoming
        ? item.incomingDate
        : item.outgoingDate;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    number,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  _StatusChip(isClosed: item.isClosed),
                  PopupMenuButton(
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text('تعديل'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 8),
                            Text('حذف'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (date != null)
                Text(
                  intl.DateFormat('yyyy/MM/dd').format(date.dateTime),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                item.correspondent?.name ?? 'غير محدد',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                item.subject?.name ?? item.summary ?? '',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  //_PriorityChip(priority: item.priorityLevel),
                  if (item.responsibleUser != null)
                    _InfoChip(
                      icon: Icons.person_outline,
                      label: item.responsibleUser!.name,
                    ),
                ],
              ),

              // Row 4: Action Buttons
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    if (item.fileId != null)
                      IconButton.filledTonal(
                        onPressed: onViewFile,
                        icon: Icon(
                          item.fileExtension == 'pdf'
                              ? Icons.picture_as_pdf_outlined
                              : Icons.image_outlined,
                        ),
                        tooltip: 'عرض الملف',
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper widgets for chips ---

class _StatusChip extends StatelessWidget {
  final bool isClosed;
  const _StatusChip({required this.isClosed});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(isClosed ? 'مغلق' : 'مفتوح'),
      labelStyle: TextStyle(
        color: isClosed
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: isClosed
          ? Theme.of(
              context,
            ).colorScheme.secondaryContainer.withValues(alpha: 0.4)
          : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.4),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

/*class _PriorityChip extends StatelessWidget {
  final PriorityLevel priority;
  const _PriorityChip({required this.priority});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (priority) {
      case PriorityLevel.high:
        label = 'هام';
        color = Colors.red.shade700;
        break;
      case PriorityLevel.medium:
        label = 'متوسط';
        color = Colors.orange.shade700;
        break;
      default:
        label = 'عادي';
        color = Colors.blue.shade700;
    }
    return _InfoChip(icon: Icons.priority_high, label: label, color: color);
  }
}*/

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Chip(
      avatar: Icon(icon, size: 16, color: chipColor),
      label: Text(label),
      labelStyle: TextStyle(color: chipColor),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
