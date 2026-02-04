import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: ListView(
        children: [
          const _SettingsHeader(title: "Display"),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme for the entire app"),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          
          const Divider(),
          const _SettingsHeader(title: "Notifications"),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text("Enable Notifications"),
            value: true,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;
  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
