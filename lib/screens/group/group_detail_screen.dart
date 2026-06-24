import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'group_tasks_tab.dart';
import 'group_chat_tab.dart';

/// Group detail — shared app-bar + custom Tasks/Chat pill switcher.
class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  int _tab = 0; // 0 = Tasks, 1 = Chat

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _DetailAppBar(onBack: () => Navigator.pop(context)),
      body: Column(
        children: [
          // ── Tab pill switcher ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Container(
              padding:    const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border:       Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _TabPill(
                      icon:     Icons.checklist_outlined,
                      label:    'Tasks',
                      isActive: _tab == 0,
                      onTap:    () => setState(() => _tab = 0),
                    ),
                  ),
                  Expanded(
                    child: _TabPill(
                      icon:     Icons.chat_bubble_outline,
                      label:    'Chat',
                      isActive: _tab == 1,
                      onTap:    () => setState(() => _tab = 1),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tab content ────────────────────────────────────────────
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: const [
                GroupTasksTab(),
                GroupChatTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── App bar ──────────────────────────────────────────────────────────────────

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;

  const _DetailAppBar({required this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  AppColors.background,
      elevation:        0,
      leadingWidth:     48,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.whiteText, size: 28),
        onPressed: onBack,
        padding: EdgeInsets.zero,
      ),
      titleSpacing: 0,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Climate Policy Brief',
            style: TextStyle(
                color: AppColors.whiteText, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'POLS 340 · 5 members',
            style: TextStyle(color: AppColors.grayText, fontSize: 12),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: AppColors.whiteText, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.whiteText, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ─── Pill tab button ──────────────────────────────────────────────────────────

class _TabPill extends StatelessWidget {
  final IconData icon;
  final String   label;
  final bool     isActive;
  final VoidCallback onTap;

  const _TabPill({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color:        isActive ? AppColors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size:  15,
                color: isActive ? Colors.white : AppColors.grayText),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color:      isActive ? Colors.white : AppColors.grayText,
                fontSize:   14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
