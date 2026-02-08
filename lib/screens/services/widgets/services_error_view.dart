import 'package:flutter/material.dart';

class ServicesErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ServicesErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("Could not connect to the Public API."),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }
}
