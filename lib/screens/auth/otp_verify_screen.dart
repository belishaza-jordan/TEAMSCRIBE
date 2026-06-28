import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _controllers = List.generate(5, (_) => TextEditingController());
  final _focusNodes  = List.generate(5, (_) => FocusNode());
  bool  _isLoading   = false;
  int   _resendSecs  = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _resendSecs = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSecs == 0) { t.cancel(); return; }
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

  String get _otp       => _controllers.map((c) => c.text).join();
  bool   get _complete  => _otp.length == 5;

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // Paste: distribute digits across all boxes
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (var i = 0; i < 5; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final next = (digits.length - 1).clamp(0, 4);
      _focusNodes[next].requestFocus();
      if (digits.length >= 5) _tryAutoSubmit();
      return;
    }
    if (value.isNotEmpty && index < 4) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_complete) _tryAutoSubmit();
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

  Future<void> _tryAutoSubmit() async {
    if (!_complete || _isLoading) return;
    await _verify();
  }

  Future<void> _resendOtp(String email) async {
    final auth = context.read<AuthProvider>();
    auth.clearError();
    await auth.forgotPassword(email);
    if (!mounted) return;
    if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent — check your email.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _verify() async {
    if (!_complete) return;
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    setState(() => _isLoading = true);

    final auth       = context.read<AuthProvider>();
    auth.clearError();
    final resetToken = await auth.verifyOtp(email, _otp);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (resetToken != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.resetPassword,
        arguments: {'email': email, 'reset_token': resetToken},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Invalid or expired OTP.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Clear boxes so user can retry
      for (final c in _controllers) { c.clear(); }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)?.settings.arguments as String? ?? '';

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
                child: const Icon(Icons.mark_email_read_outlined,
                    color: AppColors.linkBlue, size: 26),
              ),

              const SizedBox(height: 20),

              const Text(
                'Check your email',
                style: TextStyle(
                  color: AppColors.whiteText, fontSize: 26,
                  fontWeight: FontWeight.bold, letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'We sent a 5-digit code to $email',
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 14, height: 1.5),
              ),

              const SizedBox(height: 36),

              // ── OTP boxes ─────────────────────────────────────────────
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

              AppButton(
                label:     'Verify code',
                onPressed: _complete ? _verify : null,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 24),

              Center(
                child: _resendSecs > 0
                    ? Text(
                        'Resend code in ${_resendSecs}s',
                        style: const TextStyle(
                            color: AppColors.grayText, fontSize: 14),
                      )
                    : GestureDetector(
                        onTap: () => _resendOtp(email),
                        child: const Text(
                          'Resend OTP',
                          style: TextStyle(
                            color:      AppColors.linkBlue,
                            fontSize:   14,
                            fontWeight: FontWeight.w600,
                          ),
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
  final TextEditingController controller;
  final FocusNode             focusNode;
  final ValueChanged<String>  onChanged;
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
          controller:     controller,
          focusNode:      focusNode,
          textAlign:      TextAlign.center,
          keyboardType:   TextInputType.number,
          maxLength:      5, // allow paste; sliced in onChanged
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged:      onChanged,
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
