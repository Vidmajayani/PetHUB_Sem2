import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // asset image here
            ProfileHeader(
              name: auth.userProfile?.displayName ?? "Pet Lover",
              email: auth.userProfile?.email ?? "No Email",
            ),
            const SizedBox(height: 24),
            
            // Personal Info Section
            const ProfileInfoCard(),
            
            const SizedBox(height: 16),
            
            // Menu Section
            const ProfileMenu(),
          ],
        ),
      ),
    );
  }
}

