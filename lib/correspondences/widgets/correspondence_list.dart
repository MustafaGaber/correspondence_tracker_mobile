import 'package:flutter/material.dart';
import '../models/correspondence.dart';
import 'correspondence_list_item.dart'; // We'll create this next

class CorrespondenceList extends StatelessWidget {
  final List<Correspondence> correspondences;
  final ValueChanged<Correspondence> onItemTap;
  final ValueChanged<Correspondence> onEditTap;
  final ValueChanged<Correspondence> onDeleteTap;
  final ValueChanged<Correspondence> onViewFileTap;

  const CorrespondenceList({
    super.key,
    required this.correspondences,
    required this.onItemTap,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onViewFileTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: correspondences.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final item = correspondences[index];
        return CorrespondenceListItem(
          item: item,
          onTap: () => onItemTap(item),
          onEdit: () => onEditTap(item),
          onDelete: () => onDeleteTap(item),
          onViewFile: () => onViewFileTap(item),
        );
      },
    );
  }
}