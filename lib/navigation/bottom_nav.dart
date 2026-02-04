import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/notification_model.dart';
import 'package:pet_supplies_app_v2/providers/notification_provider.dart';
import 'package:pet_supplies_app_v2/screens/home/home_screen.dart';
import 'package:pet_supplies_app_v2/screens/categories/categories_screen.dart';
import 'package:pet_supplies_app_v2/screens/cart/cart_screen.dart';
import 'package:pet_supplies_app_v2/screens/profile/profile_screen.dart';
import 'package:pet_supplies_app_v2/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/providers/navigation_provider.dart';
import 'package:pet_supplies_app_v2/models/cart_model.dart';
import 'package:pet_supplies_app_v2/widgets/animations/pulsing_badge.dart';

import '../main.dart'; // To access navigatorKey

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    // Listen for real-time notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificationProvider>(context, listen: false);
      _notificationSubscription = provider.onNewNotification.listen((notification) {
        _showInAppNotification(notification);
      });
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  void _showInAppNotification(NotificationModel notification) {
    // USE THE GLOBAL NAVIGATOR KEY TO SHOW DIALOG ON TOP OF EVERYTHING
    final globalContext = PetSuppliesApp.navigatorKey.currentContext;
    if (globalContext == null) return;
    
    final colorScheme = Theme.of(globalContext).colorScheme;
    final textTheme = Theme.of(globalContext).textTheme;

    showDialog(
      context: globalContext,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                notification.title,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                notification.message,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('DISMISS', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<NavigationProvider>(globalContext, listen: false).setTab(0);
                        Navigator.pushNamed(globalContext, '/notifications');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text('VIEW ALL', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Pages for each BottomNavigationBarItem
    final List<Widget> _pages = [
      HomeScreen(key: const PageStorageKey('home')),
      CategoriesScreen(key: const PageStorageKey('categories')),
      WishlistScreen(key: const PageStorageKey('wishlist')),
      CartScreen(key: const PageStorageKey('cart')),
      ProfileScreen(key: const PageStorageKey('profile')),
    ];

    return Consumer2<NavigationProvider, CartModel>(
      builder: (context, nav, cart, child) {
        // Trigger cart reminder logic
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<NotificationProvider>().checkCartReminder(cart.items.length);
        });

        return Scaffold(
          body: IndexedStack(index: nav.selectedIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: nav.selectedIndex,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedItemColor: cs.primary,
            unselectedItemColor: cs.onSurface.withOpacity(0.6),
            onTap: (idx) => nav.setTab(idx),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: PulsingBadge(
                  count: cart.items.length,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                activeIcon: PulsingBadge(
                  count: cart.items.length,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
