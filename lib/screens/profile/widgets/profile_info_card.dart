import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider.dart';
import '../sections/edit_profile_page.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (auth.userProfile != null) {
      return Card(
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
      );
    } else {
      // Helpful prompt for old accounts or incomplete profiles
      return Card(
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
      );
    }
  }
}
