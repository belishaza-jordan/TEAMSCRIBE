import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../models/group_model.dart';
import '../../providers/group_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl  = TextEditingController();
  final _focus = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  // ── Filter real groups by query ───────────────────────────────────────

  List<GroupModel> _filteredGroups(List<GroupModel> groups) {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return groups.where((g) =>
        g.name.toLowerCase().contains(q) ||
        (g.course?.toLowerCase().contains(q) ?? false) ||
        (g.description?.toLowerCase().contains(q) ?? false)).toList();
  }


  @override
  Widget build(BuildContext context) {
    final groups = context.watch<GroupProvider>().groups;
    final matchedGroups = _filteredGroups(groups);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:        AppColors.background,
        elevation:              0,
        scrolledUnderElevation: 0,
        titleSpacing:           0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.whiteText, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color:        AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border:       Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _ctrl,
            focusNode:  _focus,
            onChanged:  (v) => setState(() => _query = v),
            style: const TextStyle(color: AppColors.whiteText, fontSize: 15),
            decoration: const InputDecoration(
              hintText:       'Search groups…',
              hintStyle:      TextStyle(color: AppColors.grayText, fontSize: 15),
              prefixIcon:     Icon(Icons.search, color: AppColors.grayText, size: 20),
              border:         InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: const [SizedBox(width: 12)],
      ),
      body: _query.isEmpty
          ? _buildIdle(groups)
          : _buildResults(matchedGroups),
    );
  }

  // ── Idle — show all groups as suggestions ─────────────────────────────

  Widget _buildIdle(List<GroupModel> groups) {
    if (groups.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, color: AppColors.grayText, size: 48),
            SizedBox(height: 12),
            Text('Type to search your groups',
                style: TextStyle(color: AppColors.grayText, fontSize: 14)),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const Text(
          'YOUR GROUPS',
          style: TextStyle(
            color:         AppColors.grayText,
            fontSize:      11,
            fontWeight:    FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        ...groups.map((g) => _GroupTile(
              group: g,
              onTap:  () => _openGroup(g),
            )),
      ],
    );
  }

  // ── Results ───────────────────────────────────────────────────────────

  Widget _buildResults(List<GroupModel> matched) {
    if (matched.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, color: AppColors.grayText, size: 48),
            const SizedBox(height: 12),
            Text(
              'No results for "$_query"',
              style: const TextStyle(color: AppColors.grayText, fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try a different name or course code',
              style: TextStyle(color: AppColors.grayText, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text(
          '${matched.length} result${matched.length == 1 ? '' : 's'} for "$_query"',
          style: const TextStyle(color: AppColors.grayText, fontSize: 12),
        ),
        const SizedBox(height: 10),
        ...matched.map((g) => _GroupTile(
              group: g,
              onTap:  () => _openGroup(g),
              highlight: _query,
            )),
      ],
    );
  }

  void _openGroup(GroupModel g) {
    Navigator.pushNamed(
      context,
      AppRoutes.groupDetail,
      arguments: {
        'id':     g.id,
        'name':   g.name,
        'course': g.course ?? '',
      },
    );
  }
}

// ─── Group tile ───────────────────────────────────────────────────────────────

class _GroupTile extends StatelessWidget {
  final GroupModel   group;
  final VoidCallback onTap;
  final String       highlight;

  const _GroupTile({
    required this.group,
    required this.onTap,
    this.highlight = '',
  });

  @override
  Widget build(BuildContext context) {
    final progress = group.progress / 100.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:        AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border:       Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color:        AppColors.linkBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.group_outlined,
                  color: AppColors.linkBlue, size: 20),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group name (bold if matches query)
                  Text(
                    group.name,
                    style: const TextStyle(
                      color:      AppColors.whiteText,
                      fontSize:   14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Course + member count
                  Text(
                    [
                      if (group.course != null && group.course!.isNotEmpty)
                        group.course!,
                      '${group.memberCount} member${group.memberCount == 1 ? '' : 's'}',
                      '${group.sectionsDone}/${group.sectionsTotal} done',
                    ].join(' · '),
                    style: const TextStyle(
                        color: AppColors.grayText, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value:           progress,
                      backgroundColor: AppColors.border,
                      color:           AppColors.blue,
                      minHeight:       3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Progress %
            Text(
              '${group.progress}%',
              style: const TextStyle(
                color:      AppColors.linkBlue,
                fontSize:   13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

