import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/screens/categories/categories_screen.dart';

class PetSection extends StatelessWidget {
  const PetSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Updated Premium Colors
    final Color csPrimary = Theme.of(context).colorScheme.primary;
    final Color csSecondary = Theme.of(context).colorScheme.secondary;
    const Color buttonTextColor = Colors.white;
    const Color textColor = Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        Widget content = Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "When you care for a pet, a special part of your heart awakens. Explore the best supplies for your furry friends!",
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(fontSize: isMobile ? 18 : 22, color: textColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: csPrimary,
                elevation: 4,
                shadowColor: Colors.black45,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 36,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "Start Shopping",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [csPrimary, csSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: csPrimary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: isMobile ? 20 : 40,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pet_image.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    content,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: content),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Image.asset(
                        'assets/images/pet_image.png',
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
