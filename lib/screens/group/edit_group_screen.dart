import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/group_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class EditGroupScreen extends StatefulWidget {
  const EditGroupScreen({super.key});

  @override
  State<EditGroupScreen> createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _courseCtrl;
  late final TextEditingController _descCtrl;
  bool _isLoading = false;
  late String _groupId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments
        as Map<String, dynamic>?;
    _groupId = args?['id'] as String? ?? '';
    _nameCtrl   = TextEditingController(text: args?['name']        as String? ?? '');
    _courseCtrl = TextEditingController(text: args?['course']       as String? ?? '');
    _descCtrl   = TextEditingController(text: args?['description']  as String? ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courseCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final provider = context.read<GroupProvider>();
    provider.clearError();

    final ok = await provider.updateGroup(
      groupId:     _groupId,
      name:        _nameCtrl.text.trim(),
      course:      _courseCtrl.text.trim(),
      description: _descCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:  Text('Group updated successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:         Text(provider.error ?? 'Update failed.'),
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
      appBar: AppBar(
        backgroundColor:        AppColors.background,
        elevation:              0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.whiteText, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit group',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              AppTextField(
                label:           'Group name',
                icon:            Icons.group_outlined,
                hintText:        'e.g. Climate Policy Brief',
                controller:      _nameCtrl,
                textInputAction: TextInputAction.next,
                validator:       Validators.required('Group name'),
              ),

              const SizedBox(height: 16),

              AppTextField(
                label:           'Course / class code',
                icon:            Icons.school_outlined,
                hintText:        'e.g. POLS 340',
                controller:      _courseCtrl,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label:           'Description (optional)',
                icon:            Icons.notes_outlined,
                hintText:        'What is this group working on?',
                controller:      _descCtrl,
                textInputAction: TextInputAction.done,
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
