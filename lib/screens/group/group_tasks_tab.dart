import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/section_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/section_provider.dart';
import '../../widgets/common/app_text_field.dart';
import '../../utils/validators.dart';

class GroupTasksTab extends StatelessWidget {
  final String groupId;
  const GroupTasksTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SectionProvider>();
    final user     = context.watch<AuthProvider>().currentUser;

    if (provider.isLoading && provider.sections.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.blue));
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            // ── Progress donut ───────────────────────────────────────
            _ProgressCard(
              done:       provider.doneCount,
              inProgress: provider.inProgressCount,
              notStarted: provider.notStartedCount,
            ),

            const SizedBox(height: 20),

            // ── Sections header ──────────────────────────────────────
            Row(
              children: [
                const Text('Sections',
                    style: TextStyle(
                        color:      AppColors.whiteText,
                        fontSize:   16,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${provider.sections.length} total',
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 13)),
              ],
            ),

            const SizedBox(height: 12),

            if (provider.sections.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'No sections yet — tap + to add one.',
                    style: TextStyle(
                        color: AppColors.grayText, fontSize: 14),
                  ),
                ),
              )
            else
              ...provider.sections.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SectionCard(
                      section: s,
                      isMe:    user?.id == s.assignedTo,
                      onTap: () => _showProgressSheet(context, s,
                          isMe: user?.id == s.assignedTo),
                    ),
                  )),
          ],
        ),

        // ── Add section FAB ──────────────────────────────────────────
        Positioned(
          bottom: 16,
          right:  16,
          child: FloatingActionButton.small(
            heroTag:         'add_section',
            backgroundColor: AppColors.blue,
            onPressed:       () => _showAddSection(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showProgressSheet(
      BuildContext context, SectionModel section, {required bool isMe}) {
    showModalBottomSheet<void>(
      context:         context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _ProgressSheet(
        section: section,
        groupId: groupId,
        isMe:    isMe,
      ),
    );
  }

  void _showAddSection(BuildContext context) {
    final ctrl    = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final members = context.read<GroupProvider>().activeGroup?.members ?? [];

    showModalBottomSheet<void>(
      context:     context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          String? selectedMemberId;

          return Padding(
            padding: EdgeInsets.fromLTRB(
                24, 20, 24,
                MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color:        AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Text('Add section',
                      style: TextStyle(
                          color:      AppColors.whiteText,
                          fontSize:   18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  AppTextField(
                    label:           'Section title',
                    icon:            Icons.article_outlined,
                    hintText:        'e.g. Introduction',
                    controller:      ctrl,
                    textInputAction: TextInputAction.next,
                    validator:       Validators.required('Section title'),
                  ),
                  const SizedBox(height: 16),
                  // ── Assign to member ─────────────────────────────────
                  if (members.isNotEmpty) ...[
                    const Text('ASSIGN TO',
                        style: TextStyle(
                            color:         AppColors.grayText,
                            fontSize:      11,
                            fontWeight:    FontWeight.w600,
                            letterSpacing: 0.8)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: members.map((m) {
                        final selected = selectedMemberId == m.id;
                        return GestureDetector(
                          onTap: () => setSheetState(() {
                            selectedMemberId =
                                selected ? null : m.id;
                          }),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.blue.withValues(alpha: 0.15)
                                  : AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppColors.blue
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: selected
                                      ? AppColors.blue
                                      : const Color(0xFF1E3A5F),
                                  child: Text(m.initials,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight:
                                              FontWeight.bold)),
                                ),
                                const SizedBox(width: 6),
                                Text(m.name.split(' ').first,
                                    style: TextStyle(
                                        color: selected
                                            ? AppColors.blue
                                            : AppColors.whiteText,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ] else
                    const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        await context.read<SectionProvider>().createSection(
                              groupId:    groupId,
                              title:      ctrl.text.trim(),
                              assignedTo: selectedMemberId,
                            );
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Add section'),
                ),
              ),
            ],
          ),
        ),
      );      // closes Padding (return statement)
    },        // closes StatefulBuilder builder: (ctx, setSheetState) { ... }
  ),          // closes StatefulBuilder(
  );          // closes showModalBottomSheet(
  }
}

// ─── Progress card ────────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final int done, inProgress, notStarted;

  const _ProgressCard({
    required this.done,
    required this.inProgress,
    required this.notStarted,
  });

  @override
  Widget build(BuildContext context) {
    final total = done + inProgress + notStarted;
    final pct   = total == 0 ? 0 : (done / total * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Donut chart
          SizedBox(
            width: 100, height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace:     3,
                    centerSpaceRadius: 34,
                    sections: [
                      PieChartSectionData(
                          value: done > 0 ? done.toDouble() : 0.001,
                          color: AppColors.blue,
                          radius: 16, title: ''),
                      PieChartSectionData(
                          value: inProgress > 0 ? inProgress.toDouble() : 0.001,
                          color: AppColors.linkBlue,
                          radius: 16, title: ''),
                      PieChartSectionData(
                          value: notStarted > 0 ? notStarted.toDouble() : 0.001,
                          color: AppColors.border,
                          radius: 16, title: ''),
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Project progress',
                  style: TextStyle(
                      color:      AppColors.whiteText,
                      fontSize:   13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _LegendRow(
                  color: AppColors.blue,     label: 'Done',
                  count: done),
              const SizedBox(height: 6),
              _LegendRow(
                  color: AppColors.linkBlue, label: 'In progress',
                  count: inProgress),
              const SizedBox(height: 6),
              _LegendRow(
                  color: AppColors.border,   label: 'Not started',
                  count: notStarted),
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

  const _LegendRow(
      {required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: AppColors.grayText, fontSize: 12)),
        const SizedBox(width: 12),
        Text('$count',
            style: const TextStyle(
                color:      AppColors.whiteText,
                fontSize:   12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final SectionModel section;
  final bool         isMe;
  final VoidCallback onTap;

  const _SectionCard({
    required this.section,
    required this.isMe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials    = section.assignedInitials ?? '?';
    final assignee    = section.assignedName
        ?? (isMe ? 'You' : 'Unassigned');
    final progressVal = section.progress / 100.0;

    Color barColor;
    switch (section.status) {
      case 'done':
        barColor = AppColors.blue;
      case 'in_progress':
        barColor = AppColors.linkBlue;
      default:
        barColor = AppColors.border;
    }

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
          Row(
            children: [
              CircleAvatar(
                radius:          18,
                backgroundColor: _avatarColor(initials),
                child: Text(initials,
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
                    Text(isMe ? '$assignee (you)' : assignee,
                        style: const TextStyle(
                            color: AppColors.grayText, fontSize: 12)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: _StatusPill(status: section.status),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value:           progressVal,
              backgroundColor: AppColors.border,
              color:           barColor,
              minHeight:       3,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Text('${section.progress}%',
                  style: const TextStyle(
                      color: AppColors.grayText, fontSize: 12)),
              if (section.dueDate != null) ...[
                const Spacer(),
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.grayText),
                const SizedBox(width: 4),
                Text(section.dueDate!,
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 12)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Status pill ──────────────────────────────────────────────────────────────

class _StatusPill extends StatelessWidget {
  final String status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color   bg, fg;

    switch (status) {
      case 'done':
        label = 'Done';
        bg    = const Color(0xFF0D4429);
        fg    = const Color(0xFF3FB950);
      case 'in_progress':
        label = 'In progress';
        bg    = const Color(0xFF1D2D45);
        fg    = AppColors.linkBlue;
      default:
        label = 'Not started';
        bg    = AppColors.surface;
        fg    = AppColors.grayText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:        bg,
        borderRadius: BorderRadius.circular(6),
        border: status == 'not_started'
            ? Border.all(color: AppColors.border)
            : null,
      ),
      child: Text(label,
          style: TextStyle(
              color:      fg,
              fontSize:   11,
              fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────

Color _avatarColor(String s) {
  const colors = [
    Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
    Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
  ];
  int h = 0;
  for (final c in s.codeUnits) { h += c; }
  return colors[h % colors.length];
}

// ─── Progress update bottom sheet ────────────────────────────────────────────

class _ProgressSheet extends StatefulWidget {
  final SectionModel section;
  final String       groupId;
  final bool         isMe;

  const _ProgressSheet({
    required this.section,
    required this.groupId,
    required this.isMe,
  });

  @override
  State<_ProgressSheet> createState() => _ProgressSheetState();
}

class _ProgressSheetState extends State<_ProgressSheet> {
  late String _status;
  late double _progress;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _status   = widget.section.status;
    _progress = widget.section.progress.toDouble();
  }

  void _onStatusChanged(String newStatus) {
    setState(() {
      _status = newStatus;
      // Snap progress to sensible defaults when status is forced
      if (newStatus == 'done')        _progress = 100;
      if (newStatus == 'not_started') _progress = 0;
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _progress = value;
      // Auto-update status based on slider value
      if (value == 100)      { _status = 'done'; }
      else if (value == 0)   { _status = 'not_started'; }
      else                   { _status = 'in_progress'; }
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await context.read<SectionProvider>().updateSection(
          groupId:   widget.groupId,
          sectionId: widget.section.id,
          status:    _status,
          progress:  _progress.round(),
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = widget.isMe;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24,
          MediaQuery.of(context).viewInsets.bottom + 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color:        AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            widget.section.title,
            style: const TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold),
          ),

          if (!canEdit) ...[
            const SizedBox(height: 8),
            const Text(
              'Only the assigned member can update this section.',
              style: TextStyle(color: AppColors.grayText, fontSize: 13),
            ),
          ],

          const SizedBox(height: 20),

          // ── Status selector ──────────────────────────────────────────
          const Text('STATUS',
              style: TextStyle(
                  color:         AppColors.grayText,
                  fontSize:      11,
                  fontWeight:    FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatusBtn(
                label:    'Not started',
                active:   _status == 'not_started',
                color:    AppColors.grayText,
                onTap:    canEdit ? () => _onStatusChanged('not_started') : null,
              ),
              const SizedBox(width: 8),
              _StatusBtn(
                label:    'In progress',
                active:   _status == 'in_progress',
                color:    AppColors.linkBlue,
                onTap:    canEdit ? () => _onStatusChanged('in_progress') : null,
              ),
              const SizedBox(width: 8),
              _StatusBtn(
                label:    'Done',
                active:   _status == 'done',
                color:    const Color(0xFF3FB950),
                onTap:    canEdit ? () => _onStatusChanged('done') : null,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Progress slider ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('PROGRESS',
                  style: TextStyle(
                      color:         AppColors.grayText,
                      fontSize:      11,
                      fontWeight:    FontWeight.w600,
                      letterSpacing: 0.8)),
              Text(
                '${_progress.round()}%',
                style: const TextStyle(
                    color:      AppColors.whiteText,
                    fontSize:   20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor:   AppColors.blue,
              inactiveTrackColor: AppColors.border,
              thumbColor:         AppColors.blue,
              overlayColor:       AppColors.blue.withValues(alpha: 0.15),
              trackHeight:        6,
            ),
            child: Slider(
              value:    _progress,
              min:      0,
              max:      100,
              divisions: 20, // 5% steps
              onChanged: canEdit ? _onSliderChanged : null,
            ),
          ),

          const SizedBox(height: 20),

          if (canEdit)
            SizedBox(
              width:  double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor:         AppColors.blue,
                  disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Save progress',
                        style: TextStyle(
                            color:      AppColors.whiteText,
                            fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusBtn extends StatelessWidget {
  final String       label;
  final bool         active;
  final Color        color;
  final VoidCallback? onTap;

  const _StatusBtn({
    required this.label,
    required this.active,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:        active
                ? color.withValues(alpha: 0.18)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? color : AppColors.border,
              width: active ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:      active ? color : AppColors.grayText,
              fontSize:   12,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
