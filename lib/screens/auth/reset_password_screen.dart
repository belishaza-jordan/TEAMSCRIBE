import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  bool  _isLoading    = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    if (!_formKey.currentState!.validate()) return;

    final args       = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    final email      = args?['email']      as String? ?? '';
    final resetToken = args?['reset_token'] as String? ?? '';

    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    auth.clearError();
    final ok = await auth.resetPassword(email, _passCtrl.text, resetToken);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      await _showSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Failed to reset password.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showSuccess() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding:
            const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                  Icons.check_circle_outline, color: Colors.green, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Password reset!',
              style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your password has been updated. You can now sign in with your new password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.grayText, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Back to sign in'),
              ),
            ),
          ],
        ),
      ),
    );
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.shield_outlined,
                      color: AppColors.linkBlue, size: 26),
                ),

                const SizedBox(height: 20),

                const Text(
                  'New password',
                  style: TextStyle(
                    color: AppColors.whiteText, fontSize: 26,
                    fontWeight: FontWeight.bold, letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Choose a strong password with at least 8 characters.',
                  style: TextStyle(
                      color: AppColors.grayText, fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 32),

                AppTextField(
                  label:           'New password',
                  icon:            Icons.lock_outline,
                  hintText:        '••••••••',
                  controller:      _passCtrl,
                  obscureText:     true,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) { return 'Password is required'; }
                    if (v.length < 8) { return 'Must be at least 8 characters'; }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                AppTextField(
                  label:           'Confirm password',
                  icon:            Icons.lock_outline,
                  hintText:        '••••••••',
                  controller:      _confirmCtrl,
                  obscureText:     true,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) { return 'Please confirm your password'; }
                    if (v != _passCtrl.text) { return 'Passwords do not match'; }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                AppButton(
                  label:     'Reset password',
                  onPressed: _reset,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
