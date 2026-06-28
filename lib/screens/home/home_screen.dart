import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/group_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupProvider>().fetchGroups();
    });
  }

  /// Returns "Good morning", "Good afternoon", or "Good evening"
  /// based on the current hour.
  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final user      = context.watch<AuthProvider>().currentUser;
    final groups    = context.watch<GroupProvider>().groups;
    final firstName = user?.name.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _HomeAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.createGroup);
          if (context.mounted) context.read<GroupProvider>().fetchGroups();
        },
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // ── Greeting ───────────────────────────────────────────────
          Text(
            '${_greeting()}, $firstName 👋',
            style: const TextStyle(
              color:         AppColors.whiteText,
              fontSize:      22,
              fontWeight:    FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Here\'s your project overview.',
            style: TextStyle(color: AppColors.grayText, fontSize: 13),
          ),

          const SizedBox(height: 20),

          // ── Stats row (driven by real group data) ──────────────────
          Row(
            children: [
              Expanded(child: _StatCard('Groups', '${groups.length}', false)),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  'Progress',
                  groups.isEmpty
                      ? '0%'
                      : '${(groups.fold<int>(0, (s, g) => s + g.progress) ~/ groups.length)}%',
                  false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  'Done',
                  '${groups.fold<int>(0, (s, g) => s + g.sectionsDone)}',
                  true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Section header ─────────────────────────────────────────
          const Text(
            'My groups',
            style: TextStyle(
              color:      AppColors.whiteText,
              fontSize:   18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          if (groups.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'No groups yet — tap + to create one.',
                  style: TextStyle(color: AppColors.grayText, fontSize: 14),
                ),
              ),
            )
          else
            ...groups.map(
              (g) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _GroupCard(
                  data: g,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.groupDetail,
                    arguments: {
                      'id':        g.id,
                      'name':      g.name,
                      'course':    g.course ?? '',
                      'join_code': g.joinCode ?? '',
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── App bar ──────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  // ignore: prefer_const_constructors_in_immutables
  _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:          AppColors.background,
      elevation:                0,
      automaticallyImplyLeading: false,
      titleSpacing:             16,
      title: Row(
        children: [
          Container(
            width:  38,
            height: 38,
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border:       Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.edit_outlined, color: AppColors.linkBlue, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'TeamScribe',
            style: TextStyle(
              color:         AppColors.whiteText,
              fontSize:      20,
              fontWeight:    FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.grayText, size: 22),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.grayText, size: 22),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatCard(this.label, this.value, this.highlight);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color:    AppColors.grayText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color:      highlight ? AppColors.linkBlue : AppColors.whiteText,
              fontSize:   26,
              fontWeight: FontWeight.bold,
              height:     1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Group card ───────────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final GroupModel   data;
  final VoidCallback onTap;

  const _GroupCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = data.progress / 100.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Expanded(
                  child: Text(
                    data.name,
                    style: const TextStyle(
                      color:      AppColors.whiteText,
                      fontSize:   15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (data.course != null && data.course!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border:       Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(data.course!,
                        style: const TextStyle(
                            color: AppColors.grayText, fontSize: 11)),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value:           progress,
                backgroundColor: AppColors.border,
                color:           AppColors.blue,
                minHeight:       3,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${data.sectionsDone}/${data.sectionsTotal} sections · ${data.progress}%',
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 12),
                  ),
                ),
                const Icon(Icons.people_outline,
                    size: 13, color: AppColors.grayText),
                const SizedBox(width: 3),
                Text('${data.memberCount} members',
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

