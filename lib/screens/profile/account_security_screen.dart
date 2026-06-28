import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class AccountSecurityScreen extends StatelessWidget {
  const AccountSecurityScreen({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete account?',
            style: TextStyle(
                color: AppColors.whiteText, fontWeight: FontWeight.bold)),
        content: const Text(
          'This will permanently delete your account and all your data. This action cannot be undone.',
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
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<AuthProvider>().logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
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
        title: const Text('Account & security',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ── Security section ───────────────────────────────────────
          _header('SECURITY'),
          _card([
            _Item(
              icon:     Icons.lock_outline,
              title:    'Change password',
              subtitle: 'Update your account password',
              onTap:    () => Navigator.pushNamed(
                  context, AppRoutes.forgotPassword),
            ),
          ]),

          const SizedBox(height: 20),

          // ── Sessions section ───────────────────────────────────────
          _header('ACTIVE SESSIONS'),
          _card([
            _Item(
              icon:     Icons.phone_android_outlined,
              title:    'This device',
              subtitle: 'Android · Active now',
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:        AppColors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Current',
                    style: TextStyle(
                        color:      AppColors.blue,
                        fontSize:   11,
                        fontWeight: FontWeight.w600)),
              ),
              showChevron: false,
            ),
          ]),

          const SizedBox(height: 20),

          // ── Danger zone ────────────────────────────────────────────
          _header('DANGER ZONE'),
          _card([
            _Item(
              icon:     Icons.delete_outline,
              title:    'Delete account',
              subtitle: 'Permanently remove your account and data',
              iconColor: AppColors.danger,
              titleColor: AppColors.danger,
              divider:  false,
              onTap:    () => _deleteAccount(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _header(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          label,
          style: const TextStyle(
            color:         AppColors.grayText,
            fontSize:      11,
            fontWeight:    FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _card(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      );
}

// ─── Row item ─────────────────────────────────────────────────────────────────

class _Item extends StatelessWidget {
  final IconData  icon;
  final String    title;
  final String    subtitle;
  final Color     iconColor;
  final Color     titleColor;
  final Widget?   trailing;
  final bool      showChevron;
  final bool      divider;
  final VoidCallback? onTap;

  const _Item({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor    = AppColors.grayText,
    this.titleColor   = AppColors.whiteText,
    this.trailing,
    this.showChevron  = true,
    this.divider      = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap:   onTap,
          leading: Icon(icon, color: iconColor, size: 20),
          title:   Text(title,
              style: TextStyle(
                  color: titleColor, fontSize: 14)),
          subtitle: Text(subtitle,
              style: const TextStyle(
                  color: AppColors.grayText, fontSize: 12)),
          trailing: trailing ??
              (showChevron
                  ? const Icon(Icons.chevron_right,
                      color: AppColors.grayText, size: 20)
                  : null),
          minLeadingWidth:  24,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        if (divider)
          const Divider(
              height: 1, color: AppColors.border, indent: 56),
      ],
    );
  }
}
