import 'package:flutter/material.dart';
import 'category_box.dart';
import 'home_section_title.dart';
import '../../../utils/ui_constants.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': '🐶', 'label': 'Dogs'},
      {'icon': '🐱', 'label': 'Cats'},
      {'icon': '🐦', 'label': 'Birds'},
      {'icon': '🐠', 'label': 'Fish'},
      {'icon': '🦎', 'label': 'Reptiles'},
      {'icon': '🐹', 'label': 'Hamsters'},
      {'icon': '🐰', 'label': 'Rabbits'},
      {'icon': '🐢', 'label': 'Turtles'},
    ];


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 12),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryBox(
                icon: cat['icon'] as String,
                label: cat['label'] as String,
                onTap: () {
                  // Navigate to product page or handle tap
                },
              );
            },
          ),
        ),


      ],
    );
  }
}
