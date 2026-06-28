import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';

/// FCM-backed notification preferences.
/// Preferences are stored in SharedPreferences and read by the FCM
/// message handler to decide whether to surface a notification.
class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  static const _keys = {
    'notif_group_messages':   true,
    'notif_task_assigned':    true,
    'notif_deadline_reminders': true,
    'notif_group_invites':    true,
    'notif_section_merged':   false,
  };

  Map<String, bool> _prefs = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _prefs = {
        for (final e in _keys.entries)
          e.key: sp.getBool(e.key) ?? e.value,
      };
      _loaded = true;
    });
  }

  Future<void> _toggle(String key, bool value) async {
    setState(() => _prefs[key] = value);
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(key, value);
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
        title: const Text('Notifications',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold)),
      ),
      body: _loaded
          ? ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              children: [
                _sectionHeader('PUSH NOTIFICATIONS'),
                _buildCard([
                  _NotifTile(
                    icon:    Icons.chat_bubble_outline,
                    title:   'Group messages',
                    subtitle: 'New messages in your groups',
                    value:   _prefs['notif_group_messages']!,
                    onChanged: (v) => _toggle('notif_group_messages', v),
                  ),
                  _NotifTile(
                    icon:    Icons.assignment_outlined,
                    title:   'Task assignments',
                    subtitle: 'When a section is assigned to you',
                    value:   _prefs['notif_task_assigned']!,
                    onChanged: (v) => _toggle('notif_task_assigned', v),
                  ),
                  _NotifTile(
                    icon:    Icons.access_alarm_outlined,
                    title:   'Deadline reminders',
                    subtitle: '24 hours before a section is due',
                    value:   _prefs['notif_deadline_reminders']!,
                    onChanged: (v) => _toggle('notif_deadline_reminders', v),
                  ),
                  _NotifTile(
                    icon:    Icons.group_add_outlined,
                    title:   'Group invites',
                    subtitle: 'When someone invites you to a group',
                    value:   _prefs['notif_group_invites']!,
                    onChanged: (v) => _toggle('notif_group_invites', v),
                  ),
                  _NotifTile(
                    icon:    Icons.merge_outlined,
                    title:   'Section merged',
                    subtitle: 'When your section is merged',
                    value:   _prefs['notif_section_merged']!,
                    onChanged: (v) => _toggle('notif_section_merged', v),
                    divider: false,
                  ),
                ]),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color:        AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border:       Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline,
                          color: AppColors.linkBlue, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Push notifications are delivered via Firebase Cloud Messaging (FCM). Make sure notifications are enabled in your device settings.',
                          style: TextStyle(
                              color: AppColors.grayText,
                              fontSize: 12,
                              height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(color: AppColors.blue)),
    );
  }

  Widget _sectionHeader(String label) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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

  Widget _buildCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: AppColors.border),
        ),
        child: Column(children: children),
      );
}

// ─── Single toggle row ────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   subtitle;
  final bool     value;
  final ValueChanged<bool> onChanged;
  final bool     divider;

  const _NotifTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading:        Icon(icon, color: AppColors.grayText, size: 20),
          title:          Text(title,
              style: const TextStyle(
                  color: AppColors.whiteText, fontSize: 14)),
          subtitle:       Text(subtitle,
              style: const TextStyle(
                  color: AppColors.grayText, fontSize: 12)),
          trailing: Switch(
            value:              value,
            onChanged:          onChanged,
            activeThumbColor:   AppColors.blue,
            activeTrackColor:   AppColors.blue.withValues(alpha: 0.3),
            inactiveThumbColor: AppColors.grayText,
            inactiveTrackColor: AppColors.border,
          ),
          minLeadingWidth: 24,
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
