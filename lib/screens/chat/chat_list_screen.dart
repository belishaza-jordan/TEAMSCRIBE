import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/group_model.dart';
import '../../providers/group_provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
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
    final groups   = provider.groups;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        scrolledUnderElevation:    0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
              color:      AppColors.whiteText,
              fontSize:   20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: provider.isLoading && groups.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue))
          : groups.isEmpty
              ? const Center(
                  child: Text(
                    'No groups yet — create or join one to start chatting.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.grayText, fontSize: 14),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: groups.length,
                  separatorBuilder: (_, index) =>
                      const Divider(height: 1, color: AppColors.border,
                          indent: 72),
                  itemBuilder: (context, i) => _GroupChatTile(
                    group: groups[i],
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.groupDetail,
                      arguments: {
                        'id':     groups[i].id,
                        'name':   groups[i].name,
                        'course': groups[i].course ?? '',
                      },
                    ),
                  ),
                ),
    );
  }
}

class _GroupChatTile extends StatelessWidget {
  final GroupModel   group;
  final VoidCallback onTap;

  const _GroupChatTile({required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initials = group.name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius:          24,
        backgroundColor: _color(initials),
        child: Text(initials,
            style: const TextStyle(
                color:      Colors.white,
                fontWeight: FontWeight.bold,
                fontSize:   14)),
      ),
      title: Text(
        group.name,
        style: const TextStyle(
            color:      AppColors.whiteText,
            fontWeight: FontWeight.w600,
            fontSize:   14),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          group.course != null && group.course!.isNotEmpty
              ? '${group.course} · ${group.memberCount} members'
              : '${group.memberCount} members',
          style: const TextStyle(color: AppColors.grayText, fontSize: 13),
        ),
      ),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.grayText, size: 18),
    );
  }

  Color _color(String s) {
    const c = [
      Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
      Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
    ];
    int h = 0;
    for (final x in s.codeUnits) { h += x; }
    return c[h % c.length];
  }
}
