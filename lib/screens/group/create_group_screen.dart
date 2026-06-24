import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
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
  String _search    = '';

  // Mock classmates list
  static const _classmates = [
    _Mate('AC', 'Alex Chen',   '@achen'),
    _Mate('MR', 'Maya Reyes',  '@mreyes'),
    _Mate('JK', 'Jordan Kim',  '@jkim'),
    _Mate('PN', 'Priya Nair',  '@pnair'),
    _Mate('DL', 'Diego Lopez', '@dlopez'),
    _Mate('HS', 'Hana Sato',   '@hsato'),
  ];

  final Set<String> _selected = {};

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courseCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    // Stub — replace with real API call
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _classmates
        .where((m) =>
            _search.isEmpty ||
            m.name.toLowerCase().contains(_search.toLowerCase()) ||
            m.username.toLowerCase().contains(_search.toLowerCase()))
        .toList();

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
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Create group',
              style: TextStyle(
                  color: AppColors.whiteText,
                  fontSize: 16,
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

              // ── Add members header ───────────────────────────────────
              const Text(
                'Add members',
                style: TextStyle(
                    color:      AppColors.whiteText,
                    fontSize:   18,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // ── Search bar ───────────────────────────────────────────
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border:       Border.all(color: AppColors.border),
                ),
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  style: const TextStyle(color: AppColors.whiteText, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Search classmates',
                    hintStyle: TextStyle(color: AppColors.grayText, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: AppColors.grayText, size: 20),
                    border:  InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Classmate list ───────────────────────────────────────
              ...filtered.map(
                (m) => _MemberTile(
                  mate:       m,
                  isSelected: _selected.contains(m.username),
                  onToggle:   () => setState(() {
                    if (_selected.contains(m.username)) {
                      _selected.remove(m.username);
                    } else {
                      _selected.add(m.username);
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Member tile ──────────────────────────────────────────────────────────────

class _MemberTile extends StatelessWidget {
  final _Mate       mate;
  final bool        isSelected;
  final VoidCallback onToggle;

  const _MemberTile(
      {required this.mate, required this.isSelected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: _avatarColor(mate.initials),
          child: Text(
            mate.initials,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        title: Text(mate.name,
            style: const TextStyle(
                color: AppColors.whiteText,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
        subtitle: Text(mate.username,
            style: const TextStyle(color: AppColors.grayText, fontSize: 13)),
        trailing: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width:  34,
            height: 34,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isSelected ? AppColors.blue : AppColors.border),
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.add,
              color: isSelected ? Colors.white : AppColors.grayText,
              size:  18,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Helpers & data ───────────────────────────────────────────────────────────

Color _avatarColor(String s) {
  const colors = [
    Color(0xFF1E3A5F), Color(0xFF1A3D2B), Color(0xFF3D1F4D),
    Color(0xFF4D2C1A), Color(0xFF1D3640), Color(0xFF3D3220),
  ];
  int h = 0;
  for (final c in s.codeUnits) { h += c; }
  return colors[h % colors.length];
}

class _Mate {
  final String initials, name, username;
  const _Mate(this.initials, this.name, this.username);
}
