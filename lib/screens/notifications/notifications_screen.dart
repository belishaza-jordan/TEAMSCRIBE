import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/activity_model.dart';
import '../../providers/progress_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().fetchNotifications();
    });
  }

  Future<void> _refresh() =>
      context.read<ProgressProvider>().fetchNotifications();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();
    final notifs   = provider.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:        AppColors.background,
        elevation:              0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.whiteText, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Text('Notifications',
                style: TextStyle(
                    color:      AppColors.whiteText,
                    fontSize:   18,
                    fontWeight: FontWeight.bold)),
            if (notifs.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color:        AppColors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${notifs.length}',
                  style: const TextStyle(
                      color:      Colors.white,
                      fontSize:   11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh,
                color: AppColors.grayText, size: 20),
            onPressed: _refresh,
          ),
        ],
      ),
      body: _buildBody(provider, notifs),
    );
  }

  Widget _buildBody(ProgressProvider provider,
      List<ActivityModel> notifs) {
    if (provider.isLoading && notifs.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.blue));
    }

    if (provider.error != null && notifs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.grayText, size: 48),
            const SizedBox(height: 12),
            Text(provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 13)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _refresh,
              child: const Text('Retry',
                  style: TextStyle(color: AppColors.linkBlue)),
            ),
          ],
        ),
      );
    }

    if (notifs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_outlined,
                color: AppColors.grayText, size: 56),
            SizedBox(height: 12),
            Text('No notifications yet',
                style: TextStyle(
                    color:      AppColors.whiteText,
                    fontSize:   16,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text('Activity from your groups will appear here.',
                style: TextStyle(
                    color: AppColors.grayText, fontSize: 13)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color:           AppColors.blue,
      backgroundColor: AppColors.surface,
      onRefresh:       _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        itemCount: notifs.length,
        separatorBuilder: (_, index) => const Divider(
            height: 1, color: AppColors.border, indent: 60),
        itemBuilder: (_, i) => _NotifTile(notif: notifs[i]),
      ),
    );
  }
}

// ─── Notification tile ────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final ActivityModel notif;
  const _NotifTile({required this.notif});

  IconData _icon() {
    switch (notif.type) {
      case 'section_done':    return Icons.check_circle_outline;
      case 'member_joined':   return Icons.person_add_outlined;
      case 'section_updated': return Icons.edit_outlined;
      default:                return Icons.notifications_outlined;
    }
  }

  Color _color() {
    switch (notif.type) {
      case 'section_done':  return const Color(0xFF3FB950);
      case 'member_joined': return AppColors.linkBlue;
      default:              return AppColors.grayText;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inHours < 1)    return '${diff.inMinutes}m ago';
    if (diff.inDays < 1)     return '${diff.inHours}h ago';
    if (diff.inDays < 7)     return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width:  42,
        height: 42,
        decoration: BoxDecoration(
          color:        color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(_icon(), color: color, size: 20),
      ),
      title: Text(
        notif.description,
        style: const TextStyle(
            color: AppColors.whiteText, fontSize: 14, height: 1.4),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          children: [
            if (notif.groupName != null) ...[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border:       Border.all(color: AppColors.border),
                ),
                child: Text(notif.groupName!,
                    style: const TextStyle(
                        color:    AppColors.grayText,
                        fontSize: 11)),
              ),
              const SizedBox(width: 6),
            ],
            Text(_timeAgo(notif.createdAt),
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
