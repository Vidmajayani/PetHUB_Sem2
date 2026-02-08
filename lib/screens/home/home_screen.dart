import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pet_supplies_app_v2/screens/home/components/pet_section.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../../providers/notification_provider.dart';
import 'components/home_header.dart';
import 'components/home_search.dart';
import 'components/home_categories.dart';
import 'components/home_promo_banner.dart';
import 'components/best_sellers.dart';
import 'components/home_footer.dart';

import 'components/home_notification_button.dart';
import 'components/pet_video_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final List<Product> products = productsProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet HUB',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          const HomeNotificationButton(),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const HomeSearch(),
            const PetVideoSection(),
            const SizedBox(height: 20),
            const HomeCategories(),
            const SizedBox(height: 20),



            const PetSection(),
            const SizedBox(height: 12),

            const HomePromoBanner(),
            const SizedBox(height: 20),
            BestSellers(products: products),
            HomeFooter(),
          ],
        ),
      ),
    );
  }
}

