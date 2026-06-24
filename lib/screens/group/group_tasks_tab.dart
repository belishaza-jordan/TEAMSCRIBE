import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../config/theme.dart';

class GroupTasksTab extends StatelessWidget {
  const GroupTasksTab({super.key});

  static const _sections = [
    _S('Introduction',      'Maya Reyes',       'MR', _St.done,       1.00, 'Updated 2h ago'),
    _S('Literature review', 'Jordan Kim',        'JK', _St.done,       1.00, 'Updated 4h ago'),
    _S('Methodology',       'Sam Taylor (you)', 'ST', _St.inProgress, 0.55, 'Active 12m ago'),
    _S('Data analysis',     'Priya Nair',        'PN', _St.inProgress, 0.30, 'Active 1h ago'),
    _S('Conclusion',        'Alex Chen',         'AC', _St.notStarted, 0.00, 'Not started'),
  ];

  static const _done       = 2;
  static const _inProgress = 2;
  static const _notStarted = 1;
  static const _total      = 5;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // ── Progress card ────────────────────────────────────────────
        _ProgressCard(
          done: _done, inProgress: _inProgress, notStarted: _notStarted),

        const SizedBox(height: 20),

        // ── Sections header ──────────────────────────────────────────
        Row(
          children: [
            const Text('Sections',
                style: TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('$_total total',
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 13)),
          ],
        ),

        const SizedBox(height: 12),

        // ── Section cards ─────────────────────────────────────────────
        ..._sections.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SectionCard(section: s),
            )),
      ],
    );
  }
}

// ─── Progress card with donut chart ──────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final int done, inProgress, notStarted;

  const _ProgressCard(
      {required this.done,
      required this.inProgress,
      required this.notStarted});

  @override
  Widget build(BuildContext context) {
    final total   = done + inProgress + notStarted;
    final pct     = total == 0 ? 0 : (done / total * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Donut
          SizedBox(
            width:  100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace:    3,
                    centerSpaceRadius: 34,
                    sections: [
                      PieChartSectionData(
                          value: done.toDouble(),
                          color: AppColors.blue,
                          radius: 16,
                          title: ''),
                      PieChartSectionData(
                          value: inProgress.toDouble(),
                          color: AppColors.linkBlue,
                          radius: 16,
                          title: ''),
                      PieChartSectionData(
                          value: notStarted.toDouble(),
                          color: AppColors.border,
                          radius: 16,
                          title: ''),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$pct%',
                        style: const TextStyle(
                            color:      AppColors.whiteText,
                            fontSize:   18,
                            fontWeight: FontWeight.bold)),
                    const Text('complete',
                        style: TextStyle(
                            color: AppColors.grayText, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Legend
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Project progress',
                  style: TextStyle(
                      color:      AppColors.whiteText,
                      fontSize:   13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _LegendRow(color: AppColors.blue,     label: 'Done',        count: done),
              const SizedBox(height: 6),
              _LegendRow(color: AppColors.linkBlue, label: 'In progress', count: inProgress),
              const SizedBox(height: 6),
              _LegendRow(color: AppColors.border,   label: 'Not started', count: notStarted),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color  color;
  final String label;
  final int    count;

  const _LegendRow({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(color: AppColors.grayText, fontSize: 12)),
        const SizedBox(width: 12),
        Text('$count',
            style: const TextStyle(
                color: AppColors.whiteText, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final _S section;

  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + name + status
          Row(
            children: [
              CircleAvatar(
                radius:          18,
                backgroundColor: _avatarColor(section.initials),
                child: Text(section.initials,
                    style: const TextStyle(
                        color:      Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:   11)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(section.title,
                        style: const TextStyle(
                            color:      AppColors.whiteText,
                            fontWeight: FontWeight.w600,
                            fontSize:   14)),
                    Text(section.assignee,
                        style: const TextStyle(
                            color: AppColors.grayText, fontSize: 12)),
                  ],
                ),
              ),
              _StatusPill(status: section.status),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value:           section.progress,
              backgroundColor: AppColors.border,
              color:           section.status == _St.done
                  ? AppColors.blue
                  : section.status == _St.inProgress
                      ? AppColors.linkBlue
                      : AppColors.border,
              minHeight: 3,
            ),
          ),

          const SizedBox(height: 10),

          // Timestamp + menu
          Row(
            children: [
              const Icon(Icons.access_time_outlined,
                  size: 12, color: AppColors.grayText),
              const SizedBox(width: 4),
              Expanded(
                child: Text(section.updatedAgo,
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 12)),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.more_vert,
                    size: 18, color: AppColors.grayText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Status pill ──────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final _St status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color   bg, fg;

    switch (status) {
      case _St.done:
        label = 'Done';
        bg    = const Color(0xFF0D4429);
        fg    = const Color(0xFF3FB950);
      case _St.inProgress:
        label = 'In progress';
        bg    = const Color(0xFF1D2D45);
        fg    = AppColors.linkBlue;
      case _St.notStarted:
        label = 'Not started';
        bg    = AppColors.surface;
        fg    = AppColors.grayText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(6),
        border:       status == _St.notStarted
            ? Border.all(color: AppColors.border)
            : null,
      ),
      child: Text(label,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Data models ──────────────────────────────────────────────────────────────

enum _St { done, inProgress, notStarted }

class _S {
  final String title, assignee, initials, updatedAgo;
  final _St    status;
  final double progress;

  const _S(this.title, this.assignee, this.initials, this.status,
      this.progress, this.updatedAgo);
}

Color _avatarColor(String s) {
  const colors = [
    Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
    Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
  ];
  int h = 0;
  for (final c in s.codeUnits) { h += c; }
  return colors[h % colors.length];
}
