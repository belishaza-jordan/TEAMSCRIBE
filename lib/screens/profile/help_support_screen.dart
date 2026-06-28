import 'package:flutter/material.dart';
import '../../config/theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _faqs = [
    _Faq(
      q: 'How do I create a group?',
      a: 'Tap the + button on the Home or Groups tab. Enter a group name and course code, then invite your classmates.',
    ),
    _Faq(
      q: 'How do I assign sections to teammates?',
      a: 'Open the group, go to the Tasks tab, and tap the ⋮ menu on any section card to assign it to a member.',
    ),
    _Faq(
      q: 'Can I upload files to a section?',
      a: 'Yes. Open a section, tap the attachment icon in the chat bar or the upload button on the section detail screen.',
    ),
    _Faq(
      q: 'How do I merge and export the final document?',
      a: 'From the group detail screen, tap Merge & Export. You can arrange sections, preview, and download a combined PDF.',
    ),
    _Faq(
      q: 'I forgot my password. What do I do?',
      a: 'On the login screen, tap "Forgot password?" and enter your email. A 5-digit OTP will be sent to reset your password.',
    ),
    _Faq(
      q: 'How do I turn off push notifications?',
      a: 'Go to Profile → Notifications and toggle off the types you don\'t want.',
    ),
  ];

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
        title: const Text('Help & support',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          // ── FAQ ────────────────────────────────────────────────────
          const _SectionHeader('FREQUENTLY ASKED QUESTIONS'),
          Container(
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border:       Border.all(color: AppColors.border),
            ),
            child: Column(
              children: _faqs
                  .map((f) => _FaqTile(faq: f))
                  .toList(),
            ),
          ),

          const SizedBox(height: 20),

          // ── Contact ────────────────────────────────────────────────
          const _SectionHeader('CONTACT'),
          Container(
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border:       Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _ContactTile(
                  icon:    Icons.mail_outline,
                  title:   'Email support',
                  subtitle: 'support@teamscribe.app',
                  onTap:   () {},
                ),
                const Divider(
                    height: 1, color: AppColors.border, indent: 56),
                _ContactTile(
                  icon:    Icons.bug_report_outlined,
                  title:   'Report a bug',
                  subtitle: 'Help us improve TeamScribe',
                  onTap:   () {},
                  divider: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Version ────────────────────────────────────────────────
          Center(
            child: Text(
              'TeamScribe v1.0.0',
              style: const TextStyle(
                  color: AppColors.grayText, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAQ tile (expandable) ────────────────────────────────────────────────────

class _FaqTile extends StatelessWidget {
  final _Faq faq;
  const _FaqTile({required this.faq});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.fromLTRB(16, 0, 16, 14),
        leading: const Icon(Icons.help_outline,
            color: AppColors.linkBlue, size: 20),
        title: Text(
          faq.q,
          style: const TextStyle(
              color: AppColors.whiteText,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
        iconColor:        AppColors.grayText,
        collapsedIconColor: AppColors.grayText,
        children: [
          Text(
            faq.a,
            style: const TextStyle(
                color: AppColors.grayText, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}

// ─── Contact tile ─────────────────────────────────────────────────────────────

class _ContactTile extends StatelessWidget {
  final IconData     icon;
  final String       title;
  final String       subtitle;
  final VoidCallback onTap;
  final bool         divider;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap:   onTap,
          leading: Icon(icon, color: AppColors.grayText, size: 20),
          title: Text(title,
              style: const TextStyle(
                  color: AppColors.whiteText, fontSize: 14)),
          subtitle: Text(subtitle,
              style: const TextStyle(
                  color: AppColors.grayText, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right,
              color: AppColors.grayText, size: 20),
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

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) => Padding(
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
}

class _Faq {
  final String q;
  final String a;
  const _Faq({required this.q, required this.a});
}
