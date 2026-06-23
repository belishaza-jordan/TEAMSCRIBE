import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/section_model.dart';
import '../../providers/section_provider.dart';
import '../../widgets/common/status_pill.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = context.watch<SectionProvider>().sections;
    final section = ModalRoute.of(context)?.settings.arguments as SectionModel?
        ?? (sections.isNotEmpty ? sections.first : null);

    if (section == null) {
      return const Scaffold(body: Center(child: Text('No task selected')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(section.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusPill(status: section.status),
            const SizedBox(height: 16),
            Text('Assigned to: ${section.assignedTo}',
                style: Theme.of(context).textTheme.bodyLarge),
            if (section.dueDate != null) ...[
              const SizedBox(height: 8),
              Text('Due: ${section.dueDate}',
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
