import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

/// "Groups" tab — shows all groups the current user belongs to.
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  static const _groups = [
    _G('Climate Policy Brief',    'POLS 340', 2, 5,  '2m ago'),
    _G('Database Systems Report', 'CS 425',   4, 6,  '12m ago'),
    _G('Marketing Launch Plan',   'MKTG 210', 9, 10, '1h ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Groups',
          style: TextStyle(
            color:      AppColors.whiteText,
            fontSize:   20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.whiteText),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.createGroup),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        children: _groups
            .map(
              (g) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _GroupRow(
                  g: g,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.groupDetail),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  final _G g;
  final VoidCallback onTap;

  const _GroupRow({required this.g, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = g.done / g.total;
    final pct      = (progress * 100).round();

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
                  child: Text(g.name,
                      style: const TextStyle(
                          color: AppColors.whiteText,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(g.course,
                      style: const TextStyle(
                          color: AppColors.grayText, fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.border,
                color: AppColors.blue,
                minHeight: 3,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text('${g.done}/${g.total} sections · $pct%',
                      style: const TextStyle(
                          color: AppColors.grayText, fontSize: 12)),
                ),
                const Icon(Icons.access_time_outlined,
                    size: 13, color: AppColors.grayText),
                const SizedBox(width: 3),
                Text(g.lastActivity,
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

class _G {
  final String name, course, lastActivity;
  final int done, total;
  const _G(this.name, this.course, this.done, this.total, this.lastActivity);
}
