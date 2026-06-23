import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../utils/validators.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

/// Login screen — entry point for returning users.
///
/// Form validates email format and non-empty password.
/// The Sign-in button shows a loading spinner on tap, then navigates
/// to [AppRoutes.home] (backend wired in a later step).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey          = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the form, simulates a network call, then pushes Home.
  Future<void> _signIn() async {
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

      // ── "New here?" link — pinned to the bottom of the screen ────────
      bottomNavigationBar: Container(
        color:   AppColors.background,
        padding: const EdgeInsets.only(bottom: 36, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'New here?  ',
              style: TextStyle(
                color:    AppColors.grayText,
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.signup),
              child: const Text(
                'Create an account',
                style: TextStyle(
                  color:      AppColors.linkBlue,
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),

      // ── Scrollable form body ──────────────────────────────────────────
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),

                // ── Logo mark ───────────────────────────────────────────
                Container(
                  width:  56,
                  height: 56,
                  decoration: BoxDecoration(
                    color:        AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border:       Border.all(color: AppColors.border),
                  ),
                  child: const Icon(
                    Icons.edit_note_outlined,
                    color: AppColors.linkBlue,
                    size:  26,
                  ),
                ),

                const SizedBox(height: 20),

                // ── App name ────────────────────────────────────────────
                const Text(
                  'TeamScribe',
                  style: TextStyle(
                    color:         AppColors.whiteText,
                    fontSize:      28,
                    fontWeight:    FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 6),

                // ── Subtitle ────────────────────────────────────────────
                const Text(
                  'Sign in with your university account',
                  style: TextStyle(
                    color:    AppColors.grayText,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 32),

                // ── University email ────────────────────────────────────
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

                // ── Password ────────────────────────────────────────────
                AppTextField(
                  label:           'Password',
                  icon:            Icons.lock_outline,
                  hintText:        '••••••••',
                  controller:      _passwordController,
                  obscureText:     true,
                  textInputAction: TextInputAction.done,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Password is required' : null,
                ),

                const SizedBox(height: 10),

                // ── Forgot password link (right-aligned) ────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {}, // stub — password-reset flow comes later
                    style: TextButton.styleFrom(
                      padding:         EdgeInsets.zero,
                      minimumSize:     Size.zero,
                      tapTargetSize:   MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color:      AppColors.linkBlue,
                        fontSize:   13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Sign in button ──────────────────────────────────────
                AppButton(
                  label:     'Sign in',
                  onPressed: _signIn,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
