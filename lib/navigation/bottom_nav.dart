import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/models/notification_model.dart';
import 'package:pet_supplies_app_v2/providers/notification_provider.dart';
import 'package:pet_supplies_app_v2/screens/home/home_screen.dart';
import 'package:pet_supplies_app_v2/screens/categories/categories_screen.dart';
import 'package:pet_supplies_app_v2/screens/cart/cart_screen.dart';
import 'package:pet_supplies_app_v2/screens/profile/profile_screen.dart';
import 'package:pet_supplies_app_v2/screens/wishlist/wishlist_screen.dart';
import 'package:pet_supplies_app_v2/screens/services/services_screen.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/providers/navigation_provider.dart';
import 'package:pet_supplies_app_v2/models/cart_model.dart';
import 'package:pet_supplies_app_v2/widgets/animations/pulsing_badge.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Pages for each BottomNavigationBarItem
    final List<Widget> _pages = [
      HomeScreen(key: const PageStorageKey('home')),
      CategoriesScreen(key: const PageStorageKey('categories')),
      ServicesScreen(key: const PageStorageKey('services')),
      WishlistScreen(key: const PageStorageKey('wishlist')),
      CartScreen(key: const PageStorageKey('cart')),
    ];

    return Consumer2<NavigationProvider, CartModel>(
      builder: (context, nav, cart, child) {
        // Trigger cart reminder logic
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<NotificationProvider>().checkCartReminder(cart.items.length);
        });

        // Safety check for index after removing an item
        final currentIndex = nav.selectedIndex >= _pages.length ? 0 : nav.selectedIndex;

        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
            child: _pages[currentIndex],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            indicatorColor: cs.primaryContainer,
            onDestinationSelected: (idx) => nav.setTab(idx),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              const NavigationDestination(
                icon: Icon(Icons.design_services_outlined),
                selectedIcon: Icon(Icons.design_services),
                label: 'Services',
              ),
              const NavigationDestination(
                icon: Icon(Icons.favorite_outline),
                selectedIcon: Icon(Icons.favorite),
                label: 'Wishlist',
              ),
              NavigationDestination(
                icon: PulsingBadge(
                  count: cart.items.length,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: PulsingBadge(
                  count: cart.items.length,
                  child: const Icon(Icons.shopping_cart),
                ),
                label: 'Cart',
              ),
            ],
          ),
        );
      },
    );
  }
}
