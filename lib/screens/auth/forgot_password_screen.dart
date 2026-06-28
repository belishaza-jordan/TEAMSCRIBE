import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  bool  _isLoading     = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email = _emailCtrl.text.trim();
    final auth  = context.read<AuthProvider>();
    auth.clearError();
    await auth.forgotPassword(email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.pushNamed(context, AppRoutes.otpVerify, arguments: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:           AppColors.background,
        elevation:                 0,
        scrolledUnderElevation:    0,
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
                  child: const Icon(Icons.lock_reset_outlined,
                      color: AppColors.linkBlue, size: 26),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: AppColors.whiteText, fontSize: 26,
                    fontWeight: FontWeight.bold, letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "No worries. Enter your university email and we'll send you a 5-digit code to reset your password.",
                  style: TextStyle(
                      color: AppColors.grayText, fontSize: 14, height: 1.5),
                ),

                const SizedBox(height: 32),

                AppTextField(
                  label:           'University email',
                  icon:            Icons.mail_outline,
                  hintText:        'you@university.edu',
                  controller:      _emailCtrl,
                  keyboardType:    TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator:       Validators.email,
                ),

                const SizedBox(height: 24),

                AppButton(
                  label:     'Send OTP',
                  onPressed: _sendOtp,
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
