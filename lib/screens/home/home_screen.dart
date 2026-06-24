import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Mock data ──────────────────────────────────────────────────────────────
  static const _groups = [
    _GroupData('Climate Policy Brief',    'POLS 340', 2, 5,  '2m ago'),
    _GroupData('Database Systems Report', 'CS 425',   4, 6,  '12m ago'),
    _GroupData('Marketing Launch Plan',   'MKTG 210', 9, 10, '1h ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _HomeAppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createGroup),
        backgroundColor: AppColors.blue,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // ── Stats row ──────────────────────────────────────────────
          Row(
            children: const [
              Expanded(child: _StatCard('Groups',   '3',  false)),
              SizedBox(width: 10),
              Expanded(child: _StatCard('Due soon', '2',  false)),
              SizedBox(width: 10),
              Expanded(child: _StatCard('Unread',   '5',  true)),
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

          // ── Group cards ────────────────────────────────────────────
          ..._groups.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _GroupCard(
                data: g,
                onTap: () => Navigator.pushNamed(context, AppRoutes.groupDetail),
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
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppColors.grayText, size: 22),
          onPressed: () {},
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
  final _GroupData data;
  final VoidCallback onTap;

  const _GroupCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pct      = (data.done / data.total * 100).round();
    final progress = data.done / data.total;

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
            // Name + course code
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border:       Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.course,
                    style: const TextStyle(color: AppColors.grayText, fontSize: 11),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Progress bar
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

            // Sections + time
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${data.done}/${data.total} sections · $pct%',
                    style: const TextStyle(color: AppColors.grayText, fontSize: 12),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time_outlined,
                        size: 13, color: AppColors.grayText),
                    const SizedBox(width: 3),
                    Text(
                      data.lastActivity,
                      style: const TextStyle(color: AppColors.grayText, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _GroupData {
  final String name;
  final String course;
  final int    done;
  final int    total;
  final String lastActivity;

  const _GroupData(this.name, this.course, this.done, this.total, this.lastActivity);
}
