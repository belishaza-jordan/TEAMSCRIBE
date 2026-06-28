import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/group_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen>
    with SingleTickerProviderStateMixin {
  final _codeCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _formKey1  = GlobalKey<FormState>();
  final _formKey2  = GlobalKey<FormState>();
  bool  _isLoading = false;
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // If opened with a group_id (from the "Invite" button), jump to email tab
    final args = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    if (args?['group_id'] != null && _tabs.index != 1) {
      _tabs.animateTo(1);
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _tabs.dispose();
    super.dispose();
  }

  // ── Join by code ────────────────────────────────────────────────────────

  Future<void> _joinByCode() async {
    if (!_formKey1.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final provider = context.read<GroupProvider>();
    provider.clearError();
    final group = await provider.joinGroup(_codeCtrl.text.trim().toUpperCase());

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (group != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You joined "${group.name}"!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade700,
        ),
      );
      // Navigate into the group detail
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.groupDetail,
        arguments: {
          'id':     group.id,
          'name':   group.name,
          'course': group.course ?? '',
        },
      );
    } else {
      _showError(provider.error ?? 'Invalid or expired code.');
    }
  }

  // ── Invite by email (for members already in the system) ────────────────

  Future<void> _inviteByEmail() async {
    if (!_formKey2.currentState!.validate()) return;

    final args    = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    final groupId = (args?['group_id'] as String?) ?? '';

    if (groupId.isEmpty) {
      _showError('Open this screen from a group\'s invite icon to send email invitations.');
      return;
    }

    setState(() => _isLoading = true);
    final provider = context.read<GroupProvider>();
    provider.clearError();
    final ok = await provider.inviteByEmail(groupId, _emailCtrl.text.trim());

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      _emailCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invitation sent! They\'ll receive an email with Accept & Decline buttons.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      _showError(provider.error ?? 'Could not send the invitation.');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(msg),
        backgroundColor: AppColors.danger,
        behavior:        SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args    = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    // fromGroup is true only when a real group ID (non-empty) was passed
    final groupIdArg = (args?['group_id'] as String?) ?? '';
    final fromGroup  = groupIdArg.isNotEmpty;

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
        title: const Text('Join or Invite',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabs,
          labelColor:        AppColors.whiteText,
          unselectedLabelColor: AppColors.grayText,
          indicatorColor:    AppColors.blue,
          tabs: const [
            Tab(text: 'Join by code'),
            Tab(text: 'Invite by email'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildJoinByCode(),
          _buildInviteByEmail(fromGroup),
        ],
      ),
    );
  }

  // ── Tab 1 — Join by code ────────────────────────────────────────────────

  Widget _buildJoinByCode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Illustration row
            Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color:        AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border:       Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.vpn_key_outlined,
                      color: AppColors.linkBlue, size: 26),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Got an invite code from a classmate? Enter it below to join their group instantly.',
                    style: TextStyle(
                        color: AppColors.grayText,
                        fontSize: 14,
                        height: 1.5),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 6-char code input
            TextFormField(
              controller:      _codeCtrl,
              textAlign:       TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              keyboardType:    TextInputType.text,
              maxLength:       6,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                UpperCaseTextFormatter(),
              ],
              style: const TextStyle(
                color:      AppColors.whiteText,
                fontSize:   28,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText:    'A1B2C3',
                hintStyle: const TextStyle(
                  color:         AppColors.grayText,
                  fontSize:      28,
                  letterSpacing: 8,
                ),
                filled:     true,
                fillColor:  AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.blue, width: 2),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().length != 6) {
                  return 'Please enter the full 6-character code';
                }
                return null;
              },
            ),

            const SizedBox(height: 28),

            AppButton(
              label:     'Join group',
              onPressed: _joinByCode,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 2 — Invite by email ─────────────────────────────────────────────

  Widget _buildInviteByEmail(bool fromGroup) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color:        AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border:       Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.person_add_outlined,
                      color: AppColors.linkBlue, size: 26),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Enter their email — they\'ll receive an invitation with Accept & Decline buttons.',
                    style: TextStyle(
                        color: AppColors.grayText,
                        fontSize: 14,
                        height: 1.5),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            AppTextField(
              label:           'Member\'s email',
              icon:            Icons.mail_outline,
              hintText:        'classmate@university.edu',
              controller:      _emailCtrl,
              keyboardType:    TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),

            const SizedBox(height: 28),

            AppButton(
              label:     'Send invitation',
              onPressed: fromGroup ? _inviteByEmail : null,
              isLoading: _isLoading,
            ),

            if (!fromGroup) ...[
              const SizedBox(height: 10),
              const Text(
                'Open this screen from a group\'s 🔑 icon to send invitations.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.grayText, fontSize: 12, height: 1.5),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Formats typed text to uppercase automatically
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue updated) {
    return updated.copyWith(text: updated.text.toUpperCase());
  }
}
