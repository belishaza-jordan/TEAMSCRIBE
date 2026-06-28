import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/section_model.dart';

class ProgressDonutChart extends StatelessWidget {
  final List<SectionModel> sections;

  const ProgressDonutChart({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const SizedBox.shrink();

    final done       = sections.where((s) => s.status == 'done').length;
    final inProgress = sections.where((s) => s.status == 'in_progress').length;
    final pending    = sections.where((s) => s.status == 'not_started').length;

    return SizedBox(
      height: 160,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 50,
          sections: [
            if (done > 0)
              PieChartSectionData(
                value: done.toDouble(),
                color: Colors.green,
                title: '$done',
                radius: 30,
              ),
            if (inProgress > 0)
              PieChartSectionData(
                value: inProgress.toDouble(),
                color: Colors.blue,
                title: '$inProgress',
                radius: 30,
              ),
            if (pending > 0)
              PieChartSectionData(
                value: pending.toDouble(),
                color: Colors.grey,
                title: '$pending',
                radius: 30,
              ),
          ],
        ),
      ),
    );
  }
}
