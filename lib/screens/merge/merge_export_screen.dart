import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/section_provider.dart';
import '../../widgets/common/app_button.dart';

class MergeExportScreen extends StatelessWidget {
  const MergeExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final group = context.watch<GroupProvider>().activeGroup;
    final sections = context.watch<SectionProvider>().sections;

    return Scaffold(
      appBar: AppBar(title: const Text('Merge & Export')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Group: ${group?.name ?? '-'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text('${sections.length} sections ready to merge'),
            const Spacer(),
            AppButton(
              label: 'Export as PDF',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export coming soon')),
                );
              },
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Export as DOCX',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
