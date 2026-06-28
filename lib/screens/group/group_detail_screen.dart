import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/group_provider.dart';
import '../../providers/section_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';
import 'group_tasks_tab.dart';
import 'group_chat_tab.dart';
import 'group_progress_tab.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  int     _tab     = 0;
  String? _groupId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args    = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    final groupId = args?['id'] as String?;

    if (groupId != null && groupId != _groupId) {
      _groupId = groupId;
      // Load full group data (includes join_code) so the invite panel works
      context.read<GroupProvider>().loadGroup(groupId);
      context.read<SectionProvider>().fetchSections(groupId);
      context.read<ChatProvider>().loadAndSubscribe(groupId);
      context.read<ProgressProvider>().loadAll(groupId);
    }
  }

  @override
  void dispose() {
    context.read<ChatProvider>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args    = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    final name     = args?['name']    as String? ?? 'Group';
    final course   = args?['course']  as String? ?? '';
    final groupId  = args?['id']      as String? ?? '';
    // Prefer the freshly-loaded group for the join code
    final activeGroup = context.watch<GroupProvider>().activeGroup;
    final currentUser = context.watch<AuthProvider>().currentUser;
    final joinCode    = activeGroup?.joinCode ?? args?['join_code'] as String?;
    final isAdmin     = currentUser != null &&
        activeGroup?.createdBy == currentUser.id;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _DetailAppBar(
        name:     name,
        course:   course,
        groupId:  groupId,
        joinCode: joinCode,
        isAdmin:  isAdmin,
        onBack:   () => Navigator.pop(context),
      ),
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
                  Expanded(
                    child: _TabPill(
                      icon:     Icons.bar_chart_outlined,
                      label:    'Progress',
                      isActive: _tab == 2,
                      onTap:    () => setState(() => _tab = 2),
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
              children: [
                GroupTasksTab(groupId: groupId),
                GroupChatTab(groupId: groupId),
                GroupProgressTab(groupId: groupId),
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
  final String       name;
  final String       course;
  final String       groupId;
  final String?      joinCode;
  final bool         isAdmin;
  final VoidCallback onBack;

  const _DetailAppBar({
    required this.name,
    required this.course,
    required this.groupId,
    required this.onBack,
    this.joinCode,
    this.isAdmin = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showJoinCode(BuildContext context) {
    showModalBottomSheet<void>(
      context:         context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _JoinCodeSheet(
        groupId:  groupId,
        joinCode: joinCode ?? '',
        isAdmin:  isAdmin,
      ),
    );
  }

  Future<void> _onMenuSelected(BuildContext context, String value) async {
    switch (value) {
      case 'members':
        _showMembersList(context);
      case 'delete':
        await _deleteGroup(context);
      case 'leave':
        await _leaveGroup(context);
      case 'edit':
        final active = context.read<GroupProvider>().activeGroup;
        await Navigator.pushNamed(
          context,
          AppRoutes.editGroup,
          arguments: {
            'id':          groupId,
            'name':        active?.name        ?? name,
            'course':      active?.course       ?? course,
            'description': active?.description ?? '',
          },
        );
    }
  }

  void _showMembersList(BuildContext context) {
    final members = context.read<GroupProvider>().activeGroup?.members ?? [];
    showModalBottomSheet<void>(
      context:         context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color:        AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                const Text('Members',
                    style: TextStyle(
                        color:      AppColors.whiteText,
                        fontSize:   18,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color:        AppColors.blue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${members.length}',
                      style: const TextStyle(
                          color: AppColors.blue, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap:      true,
            padding:         const EdgeInsets.fromLTRB(16, 4, 16, 20),
            itemCount:       members.length,
            separatorBuilder: (_, i) =>
                const Divider(height: 1, color: AppColors.border),
            itemBuilder: (_, i) {
              final m = members[i];
              return ListTile(
                leading: CircleAvatar(
                  radius:          20,
                  backgroundColor: const Color(0xFF1E3A5F),
                  child: Text(m.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                title: Text(m.name,
                    style: const TextStyle(
                        color:      AppColors.whiteText,
                        fontSize:   14,
                        fontWeight: FontWeight.w500)),
                trailing: m.role == 'admin'
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:        AppColors.blue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('Admin',
                            style: TextStyle(
                                color:      AppColors.blue,
                                fontSize:   11,
                                fontWeight: FontWeight.w600)),
                      )
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGroup(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete group?',
            style: TextStyle(
                color: AppColors.whiteText, fontWeight: FontWeight.bold)),
        content: const Text(
          'This permanently deletes the group, all messages and sections. This cannot be undone.',
          style: TextStyle(
              color: AppColors.grayText, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.grayText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete',
                style: TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<GroupProvider>().deleteGroup(groupId);
    if (!context.mounted) return;
    Navigator.of(context).pop(); // back to groups list
  }

  Future<void> _leaveGroup(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Leave group?',
            style: TextStyle(
                color: AppColors.whiteText, fontWeight: FontWeight.bold)),
        content: const Text(
          'You will lose access to this group\'s chat and tasks.',
          style: TextStyle(
              color: AppColors.grayText, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.grayText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave',
                style: TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final userId =
        context.read<AuthProvider>().currentUser?.id ?? '';
    await context.read<GroupProvider>().removeMember(groupId, userId);
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  AppColors.background,
      elevation:        0,
      scrolledUnderElevation: 0,
      leadingWidth:     48,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: AppColors.whiteText, size: 28),
        onPressed: onBack,
        padding: EdgeInsets.zero,
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
                color: AppColors.whiteText, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (course.isNotEmpty)
            Text(
              course,
              style: const TextStyle(color: AppColors.grayText, fontSize: 12),
            ),
        ],
      ),
      actions: [
        // Show join code + invite
        IconButton(
          icon: const Icon(Icons.vpn_key_outlined,
              color: AppColors.whiteText, size: 20),
          tooltip: 'Invite code',
          onPressed: () => _showJoinCode(context),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert,
              color: AppColors.whiteText, size: 22),
          color:        AppColors.surface,
          onSelected: (value) => _onMenuSelected(context, value),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'members',
              child: Row(children: [
                Icon(Icons.people_outline, color: AppColors.whiteText, size: 18),
                SizedBox(width: 10),
                Text('Members', style: TextStyle(color: AppColors.whiteText)),
              ]),
            ),
            if (isAdmin) ...[
              const PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  Icon(Icons.edit_outlined, color: AppColors.whiteText, size: 18),
                  SizedBox(width: 10),
                  Text('Edit group', style: TextStyle(color: AppColors.whiteText)),
                ]),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete_outline, color: AppColors.danger, size: 18),
                  SizedBox(width: 10),
                  Text('Delete group', style: TextStyle(color: AppColors.danger)),
                ]),
              ),
            ] else
              const PopupMenuItem(
                value: 'leave',
                child: Row(children: [
                  Icon(Icons.exit_to_app, color: AppColors.danger, size: 18),
                  SizedBox(width: 10),
                  Text('Leave group', style: TextStyle(color: AppColors.danger)),
                ]),
              ),
          ],
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

// ─── Join code bottom sheet ───────────────────────────────────────────────────

class _JoinCodeSheet extends StatefulWidget {
  final String groupId;
  final String joinCode;
  final bool   isAdmin;

  const _JoinCodeSheet({
    required this.groupId,
    required this.joinCode,
    required this.isAdmin,
  });

  @override
  State<_JoinCodeSheet> createState() => _JoinCodeSheetState();
}

class _JoinCodeSheetState extends State<_JoinCodeSheet> {
  String? _code;
  bool    _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    // Use code from navigation arg immediately if available
    if (widget.joinCode.isNotEmpty) {
      _code = widget.joinCode;
    } else {
      // Fetch directly from the API — no provider dependency
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchCode());
    }
  }

  Future<void> _fetchCode() async {
    if (!mounted) return;
    try {
      final service = context.read<GroupProvider>().service;
      final code = await service.fetchJoinCode(widget.groupId)
          .timeout(const Duration(seconds: 5));
      if (mounted) setState(() => _code = code);
    } catch (_) {
      // Network unavailable — leave _code null (shows "—")
    }
  }

  Future<void> _regenerate() async {
    setState(() => _isRegenerating = true);
    final newCode = await context
        .read<GroupProvider>()
        .regenerateCode(widget.groupId);
    if (!mounted) return;
    setState(() { _isRegenerating = false; if (newCode != null) _code = newCode; });
    if (newCode != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New code generated! Old code no longer works.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _copy() {
    if (_code == null) return;
    Clipboard.setData(ClipboardData(text: _code!));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayCode = _code;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color:        AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const Text('Group invite code',
              style: TextStyle(
                  color:      AppColors.whiteText,
                  fontSize:   18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text(
            'Share this code on WhatsApp — classmates enter it in the app to join instantly.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.grayText, fontSize: 13, height: 1.5),
          ),

          const SizedBox(height: 24),

          // Code display — shows spinner while loading or regenerating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            decoration: BoxDecoration(
              color:        AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: displayCode != null ? AppColors.blue : AppColors.border,
                width: 1.5,
              ),
            ),
            child: (_isRegenerating || displayCode == null)
                ? const SizedBox(
                    height: 44,
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.blue, strokeWidth: 2),
                    ),
                  )
                : Text(
                    displayCode,
                    style: const TextStyle(
                      color:         AppColors.whiteText,
                      fontSize:      36,
                      fontWeight:    FontWeight.bold,
                      letterSpacing: 10,
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          // ── Action buttons ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: displayCode != null ? _copy : null,
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copy'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.whiteText,
                    side:    const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape:   RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // Capture navigator BEFORE popping the sheet —
                    // after pop() the sheet context is deactivated.
                    final nav = Navigator.of(context);
                    nav.pop();
                    nav.pushNamed(
                      AppRoutes.joinGroup,
                      arguments: {'group_id': widget.groupId},
                    );
                  },
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Invite'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape:   RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),

          // ── Regenerate (admin only) ────────────────────────────────
          if (widget.isAdmin) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: _isRegenerating ? null : _regenerate,
                icon: const Icon(Icons.refresh, size: 16,
                    color: AppColors.danger),
                label: const Text(
                  'Regenerate code',
                  style: TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              ),
            ),
            const Text(
              'This invalidates the current code immediately.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grayText, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
