import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

/// Shown after registration.
/// User enters the 5-digit OTP that was emailed to them.
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _controllers = List.generate(5, (_) => TextEditingController());
  final _focusNodes  = List.generate(5, (_) => FocusNode());
  bool   _isLoading        = false;
  bool   _isSendingResend  = false; // prevents double-tap on resend
  bool   _resendCooldown   = false;
  int    _resendSecs       = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() { _resendSecs = 60; _resendCooldown = true; });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSecs == 0) {
        t.cancel();
        setState(() => _resendCooldown = false);
        return;
      }
      setState(() => _resendSecs--);
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes)  { f.dispose(); }
    _timer?.cancel();
    super.dispose();
  }

  String get _otp      => _controllers.map((c) => c.text).join();
  bool   get _complete => _otp.length == 5;

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < 5; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final next = (digits.length - 1).clamp(0, 4);
      _focusNodes[next].requestFocus();
      if (digits.length >= 5) _submit();
      return;
    }
    if (value.isNotEmpty && index < 4) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_complete) _submit();
  }

  void _onKey(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _submit() async {
    if (!_complete || _isLoading) return;
    setState(() => _isLoading = true);

    final email = context.read<AuthProvider>().currentUser?.email ?? '';
    final auth  = context.read<AuthProvider>();
    auth.clearError();

    final ok = await auth.verifyEmail(email, _otp);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      // Show error and clear boxes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text(auth.error ?? 'Invalid or expired code.'),
          backgroundColor: AppColors.danger,
          behavior:        SnackBarBehavior.floating,
        ),
      );
      for (final c in _controllers) { c.clear(); }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _resend() async {
    // Hard guard: ignore any tap while a resend is already in flight
    if (_isSendingResend || _resendCooldown) return;

    setState(() => _isSendingResend = true);

    // Start the 60-second cooldown immediately so further taps are blocked
    // even before the network call returns
    _startTimer();

    final auth = context.read<AuthProvider>();
    auth.clearError();
    final ok = await auth.resendVerificationEmail();

    if (!mounted) return;
    setState(() => _isSendingResend = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? 'New code sent — check your email.'
            : auth.error ?? 'Failed to resend.'),
        backgroundColor: ok ? null : AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // If resend failed, cancel the cooldown so user can try again sooner
    if (!ok) {
      _timer?.cancel();
      setState(() { _resendCooldown = false; _resendSecs = 0; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // Icon
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border:       Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.mark_email_read_outlined,
                    color: AppColors.linkBlue, size: 28),
              ),

              const SizedBox(height: 20),

              const Text(
                'Check your email',
                style: TextStyle(
                  color:         AppColors.whiteText,
                  fontSize:      26,
                  fontWeight:    FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'We sent a 5-digit verification code to',
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 4),

              Text(
                email,
                style: const TextStyle(
                  color:      AppColors.linkBlue,
                  fontSize:   14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 36),

              // ── 5-box OTP input ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (i) => _OtpBox(
                    controller: _controllers[i],
                    focusNode:  _focusNodes[i],
                    onChanged:  (v) => _onChanged(i, v),
                    onKey:      (e) => _onKey(i, e),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Verify button ────────────────────────────────────────
              SizedBox(
                width:  double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: (_complete && !_isLoading) ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor:         AppColors.blue,
                    disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Verify email',
                          style: TextStyle(
                              color:      AppColors.whiteText,
                              fontSize:   16,
                              fontWeight: FontWeight.w600),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Resend ───────────────────────────────────────────────
              Center(
                child: _resendCooldown
                    ? Text(
                        'Resend code in ${_resendSecs}s',
                        style: const TextStyle(
                            color: AppColors.grayText, fontSize: 14),
                      )
                    : GestureDetector(
                        onTap: _resend,
                        child: const Text(
                          'Resend code',
                          style: TextStyle(
                            color:      AppColors.linkBlue,
                            fontSize:   14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // ── Sign out ─────────────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: () async {
                    final nav = Navigator.of(context);
                    await context.read<AuthProvider>().logout();
                    if (!mounted) return;
                    nav.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
                  },
                  child: const Text(
                    'Sign out',
                    style: TextStyle(
                        color: AppColors.grayText, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single OTP digit box ─────────────────────────────────────────────────────

class _OtpBox extends StatelessWidget {
  final TextEditingController  controller;
  final FocusNode              focusNode;
  final ValueChanged<String>   onChanged;
  final ValueChanged<KeyEvent> onKey;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56, height: 62,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: onKey,
        child: TextFormField(
          controller:      controller,
          focusNode:       focusNode,
          textAlign:       TextAlign.center,
          keyboardType:    TextInputType.number,
          maxLength:       5,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged:       onChanged,
          style: const TextStyle(
            color:      AppColors.whiteText,
            fontSize:   24,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled:      true,
            fillColor:   AppColors.surface,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.blue, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
