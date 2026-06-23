import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.group_outlined), label: 'Groups'),
        NavigationDestination(
            icon: Icon(Icons.merge_outlined), label: 'Merge'),
        NavigationDestination(
            icon: Icon(Icons.person_outlined), label: 'Profile'),
      ],
    );
  }
}
