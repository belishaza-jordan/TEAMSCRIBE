import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// Derives up to 2 initials from a full name ("Sam Taylor" → "ST").
  static String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Future<void> _signOut(BuildContext context) async {
    // Capture references BEFORE any async gap — avoids "context after async"
    // issues that cause the navigation to silently do nothing.
    final nav  = Navigator.of(context);
    final auth = context.read<AuthProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      // Use the dialog's own BuildContext (ctx) for Navigator.pop calls
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Sign out?',
            style: TextStyle(color: AppColors.whiteText, fontWeight: FontWeight.bold)),
        content: const Text(
          'You will need to sign in again to access your groups.',
          style: TextStyle(color: AppColors.grayText, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.grayText)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign out',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await auth.logout();

    // Use the captured Navigator — safe to call after async gap
    nav.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user       = context.watch<AuthProvider>().currentUser;
    final groups     = context.watch<GroupProvider>().groups;
    final name       = user?.name       ?? '—';
    final email      = user?.email      ?? '—';
    final university = user?.university;
    final avatarUrl  = user?.avatarUrl;
    final initials   = _initials(name);

    // Real computed stats from loaded groups
    final totalGroups    = groups.length;
    final totalDone      = groups.fold<int>(0, (s, g) => s + g.sectionsDone);
    final totalSections  = groups.fold<int>(0, (s, g) => s + g.sectionsTotal);
    final completionPct  = totalSections > 0
        ? '${(totalDone / totalSections * 100).round()}%'
        : '0%';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        scrolledUnderElevation:    0,
        automaticallyImplyLeading: false,
        title: const Text('Profile',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   20,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── User info card ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  // Avatar — shows uploaded photo or initials fallback
                  CircleAvatar(
                    radius:          32,
                    backgroundColor: const Color(0xFF1E3A5F),
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl) as ImageProvider
                        : null,
                    child: avatarUrl == null
                        ? Text(
                            initials,
                            style: const TextStyle(
                                color:      Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:   18),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  // Name / email / university
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              color:      AppColors.whiteText,
                              fontSize:   16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(email,
                            style: const TextStyle(
                                color: AppColors.grayText, fontSize: 13)),
                        if (university != null && university.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(university,
                              style: const TextStyle(
                                  color: AppColors.grayText, fontSize: 12)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats row — real data ──────────────────────────────────
            Row(
              children: [
                Expanded(child: _StatBox('$totalGroups',   'Groups',        false)),
                const SizedBox(width: 10),
                Expanded(child: _StatBox('$totalDone',     'Sections done', false)),
                const SizedBox(width: 10),
                Expanded(child: _StatBox(completionPct,    'Completion',    true)),
              ],
            ),

            const SizedBox(height: 20),

            // ── Settings menu ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color:        AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border:       Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _SettingsItem(
                      icon:  Icons.person_outline,
                      label: 'Edit profile',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.editProfile)),
                  _divider(),
                  _SettingsItem(
                      icon:  Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.notificationsSettings)),
                  _divider(),
                  _SettingsItem(
                      icon:  Icons.lock_outline,
                      label: 'Account & security',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.accountSecurity)),
                  _divider(),
                  _SettingsItem(
                      icon:  Icons.help_outline,
                      label: 'Help & support',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.helpSupport)),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Sign out ───────────────────────────────────────────────
            GestureDetector(
              onTap: () => _signOut(context),
              child: Container(
                width:   double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border:       Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout, color: AppColors.danger, size: 18),
                    SizedBox(width: 8),
                    Text('Sign out',
                        style: TextStyle(
                            color:      AppColors.danger,
                            fontSize:   15,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _divider() =>
      const Divider(height: 1, color: AppColors.border, indent: 16);
}

// ─── Stat box ─────────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String value, label;
  final bool   highlight;

  const _StatBox(this.value, this.label, this.highlight);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border:       Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color:      highlight ? AppColors.linkBlue : AppColors.whiteText,
              fontSize:   22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.grayText, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─── Settings item ────────────────────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  final IconData      icon;
  final String        label;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:          onTap,
      leading:        Icon(icon, color: AppColors.grayText, size: 20),
      title:          Text(label,
          style: const TextStyle(color: AppColors.whiteText, fontSize: 14)),
      trailing:       const Icon(Icons.chevron_right,
          color: AppColors.grayText, size: 20),
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }
}
