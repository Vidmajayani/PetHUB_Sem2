import 'package:flutter/material.dart';
import 'category_box.dart';
import 'home_section_title.dart';
import '../../../utils/ui_constants.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'image': 'assets/images/dog.png', 'label': 'Dogs'},
      {'image': 'assets/images/cat.png', 'label': 'Cats'},
      {'image': 'assets/images/bird.png', 'label': 'Birds'},
      {'image': 'assets/images/fish.png', 'label': 'Fish'},
      {'image': 'assets/images/reptile.png', 'label': 'Reptiles'},
      {'image': 'assets/images/hamster.png', 'label': 'Hamsters'},
      {'image': 'assets/images/rabbit.png', 'label': 'Rabbits'},
      {'image': 'assets/images/turtle.png', 'label': 'Turtles'},
      {'image': 'assets/images/dog.png', 'label': 'Exotic Pets'}, // Placeholder icon
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(title: 'Categories'),
        SizedBox(
          height: UIConstants.categoryBoxHeight + 20,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryBox(
                image: cat['image'] as String,
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
