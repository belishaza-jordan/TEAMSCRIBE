import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/group_provider.dart';
import '../../widgets/common/app_text_field.dart';

/// Screen for creating a new group — group name, course code, member search.
class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _courseCtrl = TextEditingController();
  bool  _isLoading  = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courseCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final provider = context.read<GroupProvider>();
    provider.clearError();

    final group = await provider.createGroup(
      name:   _nameCtrl.text.trim(),
      course: _courseCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (group != null) {
      Navigator.pop(context); // go back — GroupsScreen will refresh
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text(provider.error!),
          backgroundColor: AppColors.danger,
          behavior:        SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Fixed "Create group" button at the bottom
      bottomNavigationBar: Container(
        color:   AppColors.background,
        padding: EdgeInsets.fromLTRB(
            16, 10, 16, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SizedBox(
          height: 50,
          child: FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor:         AppColors.blue,
              disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.55),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Text(
                    'Create group',
                    style: TextStyle(
                        color:      AppColors.whiteText,
                        fontSize:   16,
                        fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              // ── Header ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left,
                          color: AppColors.whiteText, size: 28),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Create a group',
                      style: TextStyle(
                          color:      AppColors.whiteText,
                          fontSize:   22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Group name ───────────────────────────────────────────
              AppTextField(
                label:    'Group name',
                icon:     Icons.group_outlined,
                hintText: 'e.g. Climate Policy Brief',
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Group name is required' : null,
              ),

              const SizedBox(height: 14),

              // ── Course code ──────────────────────────────────────────
              AppTextField(
                label:    'Course / class code',
                icon:     Icons.school_outlined,
                hintText: 'e.g. POLS 340',
                controller: _courseCtrl,
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 24),

              // ── How to add members ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border:       Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.vpn_key_outlined,
                        color: AppColors.linkBlue, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Members join via invite code',
                              style: TextStyle(
                                  color:      AppColors.whiteText,
                                  fontWeight: FontWeight.w600,
                                  fontSize:   14)),
                          SizedBox(height: 4),
                          Text(
                            'After creating the group you\'ll get a 6-character code. '
                            'Share it on WhatsApp — anyone who enters it joins instantly.',
                            style: TextStyle(
                                color: AppColors.grayText,
                                fontSize: 13,
                                height:   1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

