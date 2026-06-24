import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        automaticallyImplyLeading: false,
        title: const Text('Profile',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   20,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.whiteText),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── User info row ──────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius:          32,
                  backgroundColor: const Color(0xFF1E3A5F),
                  child: const Text('ST',
                      style: TextStyle(
                          color:      Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:   18)),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Sam Taylor',
                        style: TextStyle(
                            color:      AppColors.whiteText,
                            fontSize:   17,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('sam.taylor@university.edu',
                        style: TextStyle(
                            color: AppColors.grayText, fontSize: 13)),
                    SizedBox(height: 2),
                    Text('State University · Computer Science',
                        style: TextStyle(
                            color: AppColors.grayText, fontSize: 13)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Stats row ──────────────────────────────────────────────
            Row(
              children: const [
                Expanded(child: _StatBox('3',   'Groups',        false)),
                SizedBox(width: 10),
                Expanded(child: _StatBox('14',  'Sections done', false)),
                SizedBox(width: 10),
                Expanded(child: _StatBox('92%', 'On time',       true)),
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
                      icon: Icons.person_outline, label: 'Edit profile'),
                  _divider(),
                  _SettingsItem(
                      icon: Icons.notifications_outlined, label: 'Notifications'),
                  _divider(),
                  _SettingsItem(
                      icon: Icons.lock_outline, label: 'Account & security'),
                  _divider(),
                  _SettingsItem(
                      icon: Icons.help_outline, label: 'Help & support'),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Sign out button ────────────────────────────────────────
            GestureDetector(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.login),
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
                    Icon(Icons.logout, color: AppColors.grayText, size: 18),
                    SizedBox(width: 8),
                    Text('Sign out',
                        style: TextStyle(
                            color: AppColors.grayText, fontSize: 15)),
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
      Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 0);
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
  final IconData icon;
  final String   label;

  const _SettingsItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:          () {},
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
