import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../sections/edit_profile_page.dart';
import '../sections/orders_page.dart';
import '../sections/review_history_page.dart';
import '../sections/appointments_page.dart';
import '../sections/settings_page.dart';
import '../sections/help_page.dart';
import 'profile_menu_tile.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
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
            icon: Icons.rate_review_outlined,
            title: "My Reviews",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReviewHistoryPage()),
              );
            },
          ),
          ProfileMenuTile(
            icon: Icons.calendar_month_outlined,
            title: "My Appointments",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppointmentsPage()),
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
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: const Row(
                    children: [
                      Icon(Icons.logout, color: Colors.redAccent),
                      SizedBox(width: 12),
                      Text("Logout"),
                    ],
                  ),
                  content: const Text("Are you sure you want to exit? You will need to login again to access your account."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: TextStyle(color: colorScheme.outline)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await auth.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
