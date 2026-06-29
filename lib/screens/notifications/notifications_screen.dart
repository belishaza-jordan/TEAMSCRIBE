import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/activity_model.dart';
import '../../models/invitation_model.dart';
import '../../providers/progress_provider.dart';
import '../../providers/group_provider.dart';

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
      context.read<GroupProvider>().fetchInvitations();
    });
  }

  Future<void> _refresh() async {
    await Future.wait([
      context.read<ProgressProvider>().fetchNotifications(),
      context.read<GroupProvider>().fetchInvitations(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final activity   = context.watch<ProgressProvider>();
    final groups     = context.watch<GroupProvider>();
    final notifs     = activity.notifications;
    final invitations = groups.invitations;
    final total      = invitations.length + notifs.length;

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
            if (total > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color:        AppColors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$total',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.grayText, size: 20),
            onPressed: _refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        color:           AppColors.blue,
        backgroundColor: AppColors.surface,
        onRefresh:       _refresh,
        child: _buildBody(activity, groups, notifs, invitations),
      ),
    );
  }

  Widget _buildBody(
    ProgressProvider activity,
    GroupProvider groups,
    List<ActivityModel> notifs,
    List<InvitationModel> invitations,
  ) {
    if (activity.isLoading && notifs.isEmpty && invitations.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors.blue));
    }

    if (notifs.isEmpty && invitations.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(
            child: Column(
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
                Text('Group activity and invitations appear here.',
                    style: TextStyle(color: AppColors.grayText, fontSize: 13)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        // ── Pending invitations ─────────────────────────────────────────
        if (invitations.isNotEmpty) ...[
          _sectionHeader('Group Invitations', invitations.length),
          ...invitations.map((inv) => _InvitationTile(
            invitation: inv,
            onAccept:   () => _accept(inv),
            onDecline:  () => _decline(inv),
          )),
          if (notifs.isNotEmpty)
            const Divider(height: 24, color: AppColors.border, indent: 16, endIndent: 16),
        ],

        // ── Activity notifications ───────────────────────────────────────
        if (notifs.isNotEmpty) ...[
          if (invitations.isNotEmpty) _sectionHeader('Activity', notifs.length),
          ...notifs.map((n) => _NotifTile(notif: n)),
        ],
      ],
    );
  }

  Widget _sectionHeader(String label, int count) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
    child: Row(
      children: [
        Text(label,
            style: const TextStyle(
                color:      AppColors.grayText,
                fontSize:   11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6)),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color:        AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border:       Border.all(color: AppColors.border),
          ),
          child: Text('$count',
              style: const TextStyle(
                  color: AppColors.grayText, fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );

  Future<bool> _accept(InvitationModel inv) async {
    final provider = context.read<GroupProvider>();
    final group    = await provider.acceptInvitation(inv.id);
    if (!mounted) return group != null;
    if (group != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You joined \"${inv.groupName}\"!"),
        backgroundColor: const Color(0xFF238636),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pushNamed(context, AppRoutes.groupDetail, arguments: {
        'id':     group.id,
        'name':   group.name,
        'course': group.course ?? '',
      });
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(provider.error ?? 'Could not accept invitation.'),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
  }

  Future<bool> _decline(InvitationModel inv) async {
    final provider = context.read<GroupProvider>();
    final ok       = await provider.declineInvitation(inv.id);
    if (!mounted) return ok;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? 'Invitation declined.' : (provider.error ?? 'Failed.')),
      behavior: SnackBarBehavior.floating,
    ));
    return ok;
  }
}

// ─── Invitation tile ──────────────────────────────────────────────────────────

class _InvitationTile extends StatefulWidget {
  final InvitationModel    invitation;
  final Future<bool> Function() onAccept;
  final Future<bool> Function() onDecline;

  const _InvitationTile({
    required this.invitation,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<_InvitationTile> createState() => _InvitationTileState();
}

class _InvitationTileState extends State<_InvitationTile> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final inv = widget.invitation;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color:        AppColors.linkBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.group_outlined,
                      color: AppColors.linkBlue, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group invitation',
                          style: const TextStyle(
                              color:      AppColors.grayText,
                              fontSize:   11,
                              fontWeight: FontWeight.w600)),
                      Text(inv.groupName,
                          style: const TextStyle(
                              color:      AppColors.whiteText,
                              fontSize:   14,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${inv.inviterName} invited you to join this group.',
              style: const TextStyle(color: AppColors.grayText, fontSize: 13, height: 1.4),
            ),
            if (inv.groupCourse != null) ...[
              const SizedBox(height: 4),
              Text(inv.groupCourse!,
                  style: const TextStyle(
                      color: AppColors.grayText, fontSize: 12)),
            ],
            const SizedBox(height: 12),
            _busy
                ? const Center(
                    child: SizedBox(
                      height: 24, width: 24,
                      child: CircularProgressIndicator(
                          color: AppColors.blue, strokeWidth: 2),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() => _busy = true);
                            final ok = await widget.onDecline();
                            if (!ok && mounted) setState(() => _busy = false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.grayText,
                            side:    const BorderSide(color: AppColors.border),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape:   RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            setState(() => _busy = true);
                            final ok = await widget.onAccept();
                            if (!ok && mounted) setState(() => _busy = false);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

// ─── Activity notification tile ───────────────────────────────────────────────

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
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1)   return '${diff.inMinutes}m ago';
    if (diff.inDays < 1)    return '${diff.inHours}h ago';
    if (diff.inDays < 7)    return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color:        color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(_icon(), color: color, size: 20),
      ),
      title: Text(notif.description,
          style: const TextStyle(
              color: AppColors.whiteText, fontSize: 14, height: 1.4)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Row(
          children: [
            if (notif.groupName != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(4),
                  border:       Border.all(color: AppColors.border),
                ),
                child: Text(notif.groupName!,
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 11)),
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
