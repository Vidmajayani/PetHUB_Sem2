import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildContactCard(colorScheme, textTheme),
          const SizedBox(height: 24),
          Text(
            "Frequently Asked Questions",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFAQSection(
            "Shipping & Delivery 🚚",
            [
              FAQItem(
                question: "How long does delivery take?",
                answer: "Standard delivery takes 2-4 business days. Express delivery is available for Colombo and suburbs (same day).",
              ),
              FAQItem(
                question: "What are the shipping costs?",
                answer: "Flat rate of Rs. 350 for most items. Free shipping on orders over Rs. 15,000!",
              ),
            ],
            colorScheme,
          ),
          _buildFAQSection(
            "Orders & Returns 🔄",
            [
              FAQItem(
                question: "Can I return an item?",
                answer: "Yes, we have a 7-day return policy for unopened items. Perishable food items cannot be returned unless damaged.",
              ),
              FAQItem(
                question: "How do I track my order?",
                answer: "Go to 'My Orders' in your profile to see the real-time status of your delivery.",
              ),
            ],
            colorScheme,
          ),
          _buildFAQSection(
            "Pet Care Tips 🐾",
            [
              FAQItem(
                question: "What is the best food for puppies?",
                answer: "Puppies need high-protein food. We recommend the 'Premium Puppy Mix' available in our catalog.",
              ),
              FAQItem(
                question: "How often should I groom my pet?",
                answer: "It depends on the breed, but usually once every 4-6 weeks for long-haired pets.",
              ),
            ],
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.support_agent, size: 48, color: Colors.white),
          const SizedBox(height: 16),
          const Text(
            "Need Instant Help?",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Our support team is available 24/7 to assist you with your pets.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildContactButton(Icons.email, "Email Us"),
              const SizedBox(width: 12),
              _buildContactButton(Icons.phone, "Call Now"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildFAQSection(String title, List<FAQItem> items, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ExpansionTile(
                title: Text(item.question, style: const TextStyle(fontWeight: FontWeight.w500)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(item.answer, style: const TextStyle(color: Colors.black54, height: 1.5)),
                  ),
                ],
              ),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  FAQItem({required this.question, required this.answer});
}
