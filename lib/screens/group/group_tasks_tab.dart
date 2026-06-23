import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/section_provider.dart';
import '../../widgets/cards/task_card.dart';
import '../../widgets/charts/progress_donut_chart.dart';

class GroupTasksTab extends StatefulWidget {
  final String groupId;

  const GroupTasksTab({super.key, required this.groupId});

  @override
  State<GroupTasksTab> createState() => _GroupTasksTabState();
}

class _GroupTasksTabState extends State<GroupTasksTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SectionProvider>().fetchSections(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SectionProvider>();
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final sections = provider.sections;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ProgressDonutChart(sections: sections),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sections.length,
            separatorBuilder: (_, i) => const SizedBox(height: 10),
            itemBuilder: (context, index) => TaskCard(
              section: sections[index],
              onTap: () => Navigator.pushNamed(context, AppRoutes.taskDetail),
            ),
          ),
        ),
      ],
    );
  }
}
