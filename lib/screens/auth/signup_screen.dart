import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../utils/validators.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Registration (Create account) screen.
///
/// Validates all four fields before the stub network call:
///   • Full name  — required, non-empty
///   • Email      — standard email format
///   • Password   — minimum 8 characters
///   • Confirm    — must match the password field exactly
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey              = GlobalKey<FormState>();
  final _nameController       = TextEditingController();
  final _emailController      = TextEditingController();
  final _passwordController   = TextEditingController();
  final _confirmController    = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Validates the form, simulates a network call, then pushes Home.
  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200)); // stub delay
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Back chevron — no container, just the bare icon ─────────
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 8),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: AppColors.whiteText,
                  size:  28,
                ),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            // ── Scrollable form content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Heading ──────────────────────────────────────
                      const Text(
                        'Create your account',
                        style: TextStyle(
                          color:         AppColors.whiteText,
                          fontSize:      28,
                          fontWeight:    FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Subtext ──────────────────────────────────────
                      const Text(
                        'We verify your university automatically from your '
                        'school email — no approval needed.',
                        style: TextStyle(
                          color:    AppColors.grayText,
                          fontSize: 14,
                          height:   1.5,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Full name ────────────────────────────────────
                      AppTextField(
                        label:           'Full name',
                        icon:            Icons.person_outline,
                        hintText:        'Sam Taylor',
                        controller:      _nameController,
                        textInputAction: TextInputAction.next,
                        validator:       Validators.required('Full name'),
                      ),

                      const SizedBox(height: 16),

                      // ── University email ─────────────────────────────
                      AppTextField(
                        label:           'University email',
                        icon:            Icons.mail_outline,
                        hintText:        'you@university.edu',
                        controller:      _emailController,
                        keyboardType:    TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator:       Validators.email,
                      ),

                      const SizedBox(height: 16),

                      // ── Password ─────────────────────────────────────
                      AppTextField(
                        label:           'Password',
                        icon:            Icons.lock_outline,
                        hintText:        'At least 8 characters',
                        controller:      _passwordController,
                        obscureText:     true,
                        textInputAction: TextInputAction.next,
                        validator:       Validators.password,
                      ),

                      const SizedBox(height: 16),

                      // ── Confirm password ─────────────────────────────
                      AppTextField(
                        label:           'Confirm password',
                        icon:            Icons.lock_outline,
                        hintText:        'Re-enter password',
                        controller:      _confirmController,
                        obscureText:     true,
                        textInputAction: TextInputAction.done,
                        // Closure captures _passwordController so comparison
                        // always reads the current password value at validation time.
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 28),

                      // ── Create account button ────────────────────────
                      AppButton(
                        label:     'Create account',
                        onPressed: _createAccount,
                        isLoading: _isLoading,
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
