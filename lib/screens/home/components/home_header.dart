import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/notification_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Pet HUB',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          const Spacer(),
          Consumer<NotificationProvider>(
            builder: (context, provider, child) {
              final unreadCount = provider.unreadCount;
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      unreadCount > 0 ? Icons.notifications_active : Icons.notifications_none,
                      color: cs.onSurface,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 4),
          // Wrap the profile icon with GestureDetector
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile'); // profile route
            },
            child: Icon(Icons.account_circle, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
