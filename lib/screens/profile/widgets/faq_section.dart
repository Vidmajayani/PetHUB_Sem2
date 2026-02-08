import 'package:flutter/material.dart';

class FAQItem {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});
}

class FAQSection extends StatelessWidget {
  final String title;
  final List<FAQItem> items;

  const FAQSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 12),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ExpansionTile(
                title: Text(
                  item.question,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                iconColor: colorScheme.primary,
                textColor: colorScheme.primary,
                collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
                shape: const RoundedRectangleBorder(side: BorderSide.none),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Text(
                      item.answer,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 8),
      ],
    );
  }
}
