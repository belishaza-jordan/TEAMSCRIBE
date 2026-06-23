import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_avatar.dart';
import '../../widgets/common/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AppAvatar(
              name: user?.name ?? '',
              imageUrl: user?.avatarUrl,
              radius: 40,
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? '',
                style: Theme.of(context).textTheme.titleLarge),
            Text(user?.email ?? '',
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            AppButton(
              label: 'Log Out',
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
