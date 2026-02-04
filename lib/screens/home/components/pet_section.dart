import 'package:flutter/material.dart';
import 'package:pet_supplies_app_v2/screens/categories/categories_screen.dart';

class PetSection extends StatelessWidget {
  const PetSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed colors
    const Color sectionBackground = Color.fromARGB(255, 219, 170, 249);
    const Color buttonColor = Color.fromARGB(255, 151, 18, 246);
    const Color buttonTextColor = Colors.white;
    const Color textColor = Colors.black87;

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
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Start Shopping"),
            ),
          ],
        );

        return Container(
          color: sectionBackground,
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
