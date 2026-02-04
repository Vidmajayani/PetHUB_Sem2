import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_tile.dart';
import 'sections/edit_profile_page.dart';
import 'sections/orders_page.dart';
import 'sections/settings_page.dart';
import 'sections/help_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;
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
            if (auth.userProfile != null)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone_outlined, color: Colors.blue),
                        title: const Text("Phone Number"),
                        subtitle: Text(auth.userProfile!.phoneNumber),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.home_outlined, color: Colors.green),
                        title: const Text("Shipping Address"),
                        subtitle: Text(auth.userProfile!.address),
                      ),
                    ],
                  ),
                ),
              )
            else
              // Helpful prompt for old accounts or incomplete profiles
              Card(
                color: colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.onSecondaryContainer, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        "Your profile is incomplete!",
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Help us serve you better by adding your phone and address.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSecondaryContainer),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EditProfilePage()),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text("Complete Profile Now"),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ProfileMenuTile(
                    icon: Icons.edit_outlined,
                    title: "Edit Profile",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfilePage(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OrdersPage()),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.help_outline,
                    title: "Help & Support",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HelpPage()),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.logout,
                    title: "Logout",
                    onTap: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
