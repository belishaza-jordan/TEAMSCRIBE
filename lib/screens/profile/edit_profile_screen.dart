import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../utils/validators.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey      = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _uniCtrl;
  bool  _isLoading    = false;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _uniCtrl  = TextEditingController(text: user?.university ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _uniCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // close bottom sheet
    final picked = await ImagePicker().pickImage(
      source:    source,
      imageQuality: 80,
      maxWidth:  512,
      maxHeight: 512,
    );
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
  }

  void _showImageOptions() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.whiteText),
              title: const Text('Take photo',
                  style: TextStyle(color: AppColors.whiteText)),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.whiteText),
              title: const Text('Choose from gallery',
                  style: TextStyle(color: AppColors.whiteText)),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();
    auth.clearError();

    // Upload avatar first if a new one was picked
    if (_pickedImage != null) {
      await auth.uploadAvatar(_pickedImage!);
      if (!mounted) return;
      if (auth.error != null) {
        setState(() => _isLoading = false);
        _showError(auth.error!);
        return;
      }
    }

    // Update name + university
    final ok = await auth.updateProfile(
      _nameCtrl.text.trim(),
      _uniCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      _showError(auth.error ?? 'Update failed.');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final user      = context.watch<AuthProvider>().currentUser;
    final avatarUrl = _pickedImage == null ? user?.avatarUrl : null;
    final initials  = _initials(user?.name ?? '');

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
        title: const Text('Edit profile',
            style: TextStyle(
                color:      AppColors.whiteText,
                fontSize:   18,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 28),

              // ── Avatar ─────────────────────────────────────────────
              GestureDetector(
                onTap: _showImageOptions,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius:          52,
                      backgroundColor: const Color(0xFF1E3A5F),
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!) as ImageProvider
                          : avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                      child: (_pickedImage == null && avatarUrl == null)
                          ? Text(
                              initials,
                              style: const TextStyle(
                                color:      Colors.white,
                                fontSize:   26,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color:        AppColors.blue,
                          shape:        BoxShape.circle,
                          border:       Border.all(
                              color: AppColors.background, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Tap to change photo',
                style: const TextStyle(
                    color: AppColors.grayText, fontSize: 12),
              ),

              const SizedBox(height: 32),

              // ── Name ───────────────────────────────────────────────
              AppTextField(
                label:           'Full name',
                icon:            Icons.person_outline,
                hintText:        'Your full name',
                controller:      _nameCtrl,
                textInputAction: TextInputAction.next,
                validator:       Validators.required('Full name'),
              ),

              const SizedBox(height: 16),

              // ── University ─────────────────────────────────────────
              AppTextField(
                label:           'University',
                icon:            Icons.school_outlined,
                hintText:        'e.g. MIT, Stanford, UCT',
                controller:      _uniCtrl,
                textInputAction: TextInputAction.done,
                validator:       Validators.required('University'),
              ),

              const SizedBox(height: 32),

              AppButton(
                label:     'Save changes',
                onPressed: _save,
                isLoading: _isLoading,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
