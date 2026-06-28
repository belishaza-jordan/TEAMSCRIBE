import 'package:flutter/material.dart';
import '../../models/group_model.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onTap;

  const GroupCard({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            group.name.isNotEmpty ? group.name[0].toUpperCase() : 'G',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        title: Text(group.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${group.memberCount} members',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
