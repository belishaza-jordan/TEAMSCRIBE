import 'package:flutter/material.dart';
import '../../models/section_model.dart';
import '../common/status_pill.dart';

class TaskCard extends StatelessWidget {
  final SectionModel section;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.section, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(section.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Assigned to: ${section.assignedTo}'),
        trailing: StatusPill(status: section.status),
      ),
    );
  }
}
