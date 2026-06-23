import 'package:flutter/material.dart';
import '../../models/section_model.dart';

class StatusPill extends StatelessWidget {
  final SectionStatus status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      SectionStatus.pending => ('Pending', Colors.grey),
      SectionStatus.inProgress => ('In Progress', Colors.blue),
      SectionStatus.submitted => ('Submitted', Colors.orange),
      SectionStatus.approved => ('Approved', Colors.green),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
