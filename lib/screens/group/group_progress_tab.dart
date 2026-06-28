import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/activity_model.dart';
import '../../providers/progress_provider.dart';

/// Pure display widget — the parent GroupDetailScreen owns the loading.
/// This avoids the "Provider not found" error that occurs when a child
/// widget inside IndexedStack tries to access providers during its own
/// lifecycle methods.
class GroupProgressTab extends StatelessWidget {
  final String groupId;
  const GroupProgressTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();

    if (provider.isLoading && provider.members.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.blue));
    }

    return RefreshIndicator(
      color:        AppColors.blue,
      backgroundColor: AppColors.surface,
      onRefresh: () => context.read<ProgressProvider>().loadAll(groupId),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [

          // ── Member scorecards ────────────────────────────────────────
          const _SectionHeader('MEMBER PROGRESS'),
          const SizedBox(height: 10),

          if (provider.members.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No member data yet.',
                    style: TextStyle(color: AppColors.grayText)),
              ),
            )
          else
            ...provider.members.map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _MemberCard(member: m),
                )),

          const SizedBox(height: 20),

          // ── Activity feed ─────────────────────────────────────────────
          const _SectionHeader('RECENT ACTIVITY'),
          const SizedBox(height: 10),

          if (provider.activities.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('No activity yet — update a section to get started.',
                    style: TextStyle(
                        color: AppColors.grayText, fontSize: 13)),
              ),
            )
          else
            ...provider.activities.map((a) => _ActivityTile(activity: a)),
        ],
      ),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          color:         AppColors.grayText,
          fontSize:      11,
          fontWeight:    FontWeight.w600,
          letterSpacing: 0.8,
        ),
      );
}

// ─── Member scorecard ─────────────────────────────────────────────────────────

class _MemberCard extends StatelessWidget {
  final MemberProgressModel member;
  const _MemberCard({required this.member});

  Color _rateColor(int rate) {
    if (rate >= 75) return const Color(0xFF3FB950); // green
    if (rate >= 40) return AppColors.linkBlue;
    return AppColors.danger;
  }

  String _lastSeen(String? iso) {
    if (iso == null) return 'No activity yet';
    final diff = DateTime.now().difference(DateTime.parse(iso));
    if (diff.inMinutes < 1)   return 'Just now';
    if (diff.inHours < 1)     return '${diff.inMinutes}m ago';
    if (diff.inDays < 1)      return '${diff.inHours}h ago';
    if (diff.inDays < 7)      return '${diff.inDays}d ago';
    return 'Over a week ago';
  }

  @override
  Widget build(BuildContext context) {
    final rate      = member.completionRate;
    final rateColor = _rateColor(rate);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius:          22,
                backgroundColor: const Color(0xFF1E3A5F),
                backgroundImage: member.avatarUrl != null
                    ? NetworkImage(member.avatarUrl!) as ImageProvider
                    : null,
                child: member.avatarUrl == null
                    ? Text(member.initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13))
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(member.name,
                            style: const TextStyle(
                                color:      AppColors.whiteText,
                                fontWeight: FontWeight.w600,
                                fontSize:   14)),
                        if (member.role == 'admin') ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:        AppColors.blue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Admin',
                                style: TextStyle(
                                    color:    AppColors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(_lastSeen(member.lastActiveAt),
                        style: const TextStyle(
                            color: AppColors.grayText, fontSize: 11)),
                  ],
                ),
              ),

              // Completion rate badge
              Container(
                width:  52,
                height: 52,
                decoration: BoxDecoration(
                  color:        rateColor.withValues(alpha: 0.12),
                  shape:        BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$rate%',
                        style: TextStyle(
                            color:      rateColor,
                            fontSize:   14,
                            fontWeight: FontWeight.bold)),
                    Text('done',
                        style: TextStyle(
                            color:    rateColor,
                            fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value:           member.avgProgress / 100.0,
              backgroundColor: AppColors.border,
              color:           rateColor,
              minHeight:       6,
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                '${member.sectionsDone}/${member.sectionsTotal} sections complete',
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 12),
              ),
              const Spacer(),
              Text(
                'avg ${member.avgProgress}%',
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Activity tile ────────────────────────────────────────────────────────────

class _ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  const _ActivityTile({required this.activity});

  IconData _icon() {
    switch (activity.type) {
      case 'section_done':    return Icons.check_circle_outline;
      case 'member_joined':   return Icons.person_add_outlined;
      default:                return Icons.edit_outlined;
    }
  }

  Color _color() {
    switch (activity.type) {
      case 'section_done':  return const Color(0xFF3FB950);
      case 'member_joined': return AppColors.linkBlue;
      default:              return AppColors.grayText;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inHours < 1)    return '${diff.inMinutes}m ago';
    if (diff.inDays < 1)     return '${diff.inHours}h ago';
    if (diff.inDays < 7)     return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width:  36,
            height: 36,
            decoration: BoxDecoration(
              color:        color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(_icon(), color: color, size: 18),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.description,
                    style: const TextStyle(
                        color: AppColors.whiteText, fontSize: 13, height: 1.4)),
                const SizedBox(height: 2),
                Text(_timeAgo(activity.createdAt),
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
