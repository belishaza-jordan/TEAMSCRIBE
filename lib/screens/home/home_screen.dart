import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';
import '../../widgets/cards/group_card.dart';
import '../../widgets/common/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroupProvider>().fetchGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groupProvider = context.watch<GroupProvider>();
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user?.name ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: groupProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupProvider.groups.isEmpty
              ? const Center(child: Text('No groups yet. Create one!'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupProvider.groups.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final group = groupProvider.groups[index];
                    return GroupCard(
                      group: group,
                      onTap: () {
                        context.read<GroupProvider>().selectGroup(group.id);
                        Navigator.pushNamed(context, AppRoutes.groupDetail);
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createGroup),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
