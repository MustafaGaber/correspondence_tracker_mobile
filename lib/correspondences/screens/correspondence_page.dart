import 'package:correspondence_tracker/correspondences/cubit/correspondences_cubit.dart';
import 'package:correspondence_tracker/correspondences/cubit/correspondences_state.dart';
import 'package:correspondence_tracker/shared/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/correspondence.dart';
import '../widgets/detail_info_section.dart';
import '../widgets/reminder_list_view.dart'; // We will create this

class CorrespondenceDetailPage extends StatefulWidget {
  final String correspondenceId;

  const CorrespondenceDetailPage(this.correspondenceId, {super.key});

  @override
  State<CorrespondenceDetailPage> createState() =>
      _CorrespondenceDetailPageState();
}

class _CorrespondenceDetailPageState extends State<CorrespondenceDetailPage> {
  void _onEdit() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تعديل الخطاب')));
  }

  void _onClose() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('إغلاق الخطاب')));
  }

  void _onViewFile() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('عرض الملف')));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocSelector<CorrespondencesCubit, CorrespondencesState, Correspondence>(
        selector: (state) => state.correspondences.firstWhere(
          (c) => c.id == widget.correspondenceId,
        ),
        builder: (context, correspondence) {
          String title =
              'خطاب ${correspondence.direction == CorrespondenceDirection.incoming ? 'وارد${correspondence.incomingNumber?.isEmpty ?? false ? '' : ' رقم ${correspondence.incomingNumber}'}' : 'صادر${correspondence.outgoingNumber?.isEmpty ?? false ? '' : ' رقم ${correspondence.outgoingNumber}'}'}';

          return Scaffold(
            appBar: AppBar(
              title: Text(title),
              actions: [
                if (correspondence.fileId != null)
                  IconButton(
                    icon: const Icon(Icons.file_present),
                    tooltip: 'عرض الملف',
                    onPressed: _onViewFile,
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') _onEdit();
                    if (value == 'close') _onClose();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 8),
                          Text('تعديل الخطاب'),
                        ],
                      ),
                    ),
                    if (!correspondence.isClosed)
                      const PopupMenuItem(
                        value: 'close',
                        child: Row(
                          children: [
                            Icon(Icons.lock_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text('إغلاق الخطاب'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              // Page padding is applied here
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Core Details (Now flat and integrated)
                  DetailInfoSection(correspondence: correspondence),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // 2. Content & Summary
                  _SectionHeader(title: 'المحتوى والملخص'),
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    margin: const EdgeInsets.only(top: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            correspondence.content ?? 'لا يوجد محتوى.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (correspondence.summary != null &&
                              correspondence.summary!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            const Divider(),
                            Text(
                              'ملخص:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              correspondence.summary!,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // _SectionHeader(title: 'المتابعات (${correspondence.followUps.length})'),
                  //  FollowUpListView(followUps: correspondence.followUps),
                  const SizedBox(height: 30),

                  _SectionHeader(
                    title: 'التذكيرات (${correspondence.reminders.length})',
                  ),
                  ReminderListView(reminders: correspondence.reminders),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
