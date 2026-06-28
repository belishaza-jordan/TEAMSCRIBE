import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final String status; // 'not_started' | 'in_progress' | 'done'

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color  color;

    switch (status) {
      case 'done':
        label = 'Done';
        color = Colors.green;
      case 'in_progress':
        label = 'In Progress';
        color = Colors.blue;
      default:
        label = 'Not Started';
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color:        color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border:       Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
