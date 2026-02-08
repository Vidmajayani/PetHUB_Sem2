import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/products_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/navigation_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/order_provider.dart';
import 'providers/location_provider.dart';
import 'providers/review_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/login/login_screen.dart';

import 'screens/register/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'navigation/bottom_nav.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/categories/category_products_screen.dart';
import 'screens/product_details/product_details_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'models/product_model.dart';
import 'models/cart_model.dart';
import 'screens/notifications/notifications_screen.dart';
import 'widgets/smart_notification_banner.dart';
import 'services/payment_service.dart';
import 'dart:async';
import 'models/notification_model.dart';
import 'widgets/global_offline_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Stripe Service
  final paymentService = RipplePaymentService();
  await paymentService.init();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],

      child: const PetSuppliesApp(),
    ),
  );
}

class PetSuppliesApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const PetSuppliesApp({super.key});

  @override
  State<PetSuppliesApp> createState() => _PetSuppliesAppState();
}

class _PetSuppliesAppState extends State<PetSuppliesApp> {
  StreamSubscription? _notificationSubscription;
  OverlayEntry? _overlayEntry;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    // Start listening for notifications globally
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificationProvider>(context, listen: false);
      _notificationSubscription = provider.onNewNotification.listen((notification) {
        _showNotificationBanner(notification);
      });
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _bannerTimer?.cancel();
    _removeBanner();
    super.dispose();
  }

  void _showNotificationBanner(NotificationModel notification) {
    _removeBanner(); // Remove existing banner if any

    final overlay = PetSuppliesApp.navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          tween: Tween(begin: const Offset(0, -1), end: const Offset(0, 0)),
          builder: (context, offset, child) {
            return FractionalTranslation(
              translation: offset,
              child: child,
            );
          },
          child: SmartNotificationBanner(
            notification: notification,
            onTap: () {
              _removeBanner();
              if (notification.title.toLowerCase().contains('cart')) {
                PetSuppliesApp.navigatorKey.currentState?.pushNamed('/cart');
              } else {
                PetSuppliesApp.navigatorKey.currentState?.pushNamed('/notifications');
              }
            },
            onDismiss: () => _removeBanner(),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);

    // Reset and start auto-dismiss timer (Increased visibility to 6 seconds)
    _bannerTimer?.cancel();
    _bannerTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) _removeBanner();
    });
  }

  void _removeBanner() {
    _bannerTimer?.cancel();
    _bannerTimer = null;
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      // Force a micro-rebuild if needed to ensure UI state is clean
      if (mounted) setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    
    return MaterialApp(
      navigatorKey: PetSuppliesApp.navigatorKey,
      title: 'Pet Supplies System',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: '/login',
      builder: (context, child) {
        return Consumer<ProductsProvider>(
          builder: (context, productsProvider, _) {
            return Column(
              children: [
                GlobalOfflineBanner(isOffline: productsProvider.isOffline),
                Expanded(child: child!),
              ],
            );
          },
        );
      },
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/nav': (context) => const BottomNav(),
        '/categories': (context) => const CategoriesScreen(),
        '/cart': (context) => CartScreen(),
        '/profile': (context) => ProfileScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}
