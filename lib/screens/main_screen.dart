import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'home/home_screen.dart';
import 'group/groups_screen.dart';
import 'chat/chat_list_screen.dart';
import 'profile/profile_screen.dart';

/// Root shell that holds the four main tabs with a shared bottom nav bar.
/// Group detail and other sub-screens are pushed on top of this via the root
/// navigator, so the bottom nav disappears naturally.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    GroupsScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // IndexedStack keeps each tab alive so state is preserved on switch.
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

// ─── Bottom navigation bar ────────────────────────────────────────────────────

class _AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AppBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _NavItem(icon: Icons.home_outlined,      activeIcon: Icons.home,            label: 'Home',    index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.group_outlined,     activeIcon: Icons.group,           label: 'Groups',  index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble,    label: 'Chat',    index: 2, current: currentIndex, onTap: onTap, badge: true),
              _NavItem(icon: Icons.person_outline,     activeIcon: Icons.person,          label: 'Profile', index: 3, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;
  final bool badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  active ? activeIcon : icon,
                  color: active ? AppColors.whiteText : AppColors.grayText,
                  size: 23,
                ),
                if (badge)
                  Positioned(
                    top: -2,
                    right: -3,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: active ? AppColors.whiteText : AppColors.grayText,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
