import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/group_model.dart';
import '../../providers/group_provider.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupProvider>().fetchGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroupProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        scrolledUnderElevation:    0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Groups',
          style: TextStyle(
              color: AppColors.whiteText,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          // Join a group by code
          IconButton(
            icon: const Icon(Icons.login_outlined, color: AppColors.whiteText),
            tooltip: 'Join a group',
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.joinGroup);
              if (context.mounted) {
                context.read<GroupProvider>().fetchGroups();
              }
            },
          ),
          // Create a new group
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.whiteText),
            tooltip: 'Create a group',
            onPressed: () async {
              await Navigator.pushNamed(context, AppRoutes.createGroup);
              if (context.mounted) {
                context.read<GroupProvider>().fetchGroups();
              }
            },
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(GroupProvider provider) {
    if (provider.isLoading && provider.groups.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.blue));
    }

    if (provider.error != null && provider.groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.grayText, size: 48),
            const SizedBox(height: 12),
            Text(provider.error!,
                style: const TextStyle(color: AppColors.grayText)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<GroupProvider>().fetchGroups(),
              child: const Text('Retry',
                  style: TextStyle(color: AppColors.linkBlue)),
            ),
          ],
        ),
      );
    }

    if (provider.groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_outlined,
                color: AppColors.grayText, size: 56),
            const SizedBox(height: 12),
            const Text('No groups yet',
                style: TextStyle(
                    color: AppColors.whiteText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('Tap + to create your first group',
                style: TextStyle(color: AppColors.grayText, fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: provider.groups.length,
      separatorBuilder: (_, index) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _GroupCard(
        group: provider.groups[i],
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.groupDetail,
          arguments: {
            'id':        provider.groups[i].id,
            'name':      provider.groups[i].name,
            'course':    provider.groups[i].course ?? '',
            'join_code': provider.groups[i].joinCode ?? '',
          },
        ),
      ),
    );
  }
}

// ─── Group card ───────────────────────────────────────────────────────────────

class _GroupCard extends StatelessWidget {
  final GroupModel   group;
  final VoidCallback onTap;

  const _GroupCard({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = group.progress / 100.0;

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
                  child: Text(group.name,
                      style: const TextStyle(
                          color:      AppColors.whiteText,
                          fontSize:   15,
                          fontWeight: FontWeight.w600)),
                ),
                if (group.course != null && group.course!.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border:       Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(group.course!,
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
                    '${group.sectionsDone}/${group.sectionsTotal} sections · ${group.progress}%',
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 12),
                  ),
                ),
                const Icon(Icons.people_outline,
                    size: 13, color: AppColors.grayText),
                const SizedBox(width: 3),
                Text(
                  '${group.memberCount} members',
                  style: const TextStyle(
                      color: AppColors.grayText, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
