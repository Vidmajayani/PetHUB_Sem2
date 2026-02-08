import 'package:flutter/material.dart';
import '../widgets/help_page_header.dart';
import '../widgets/faq_section.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium Header with Gradient
          const HelpPageHeader(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Frequently Asked Questions",
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const FAQSection(
                    title: "Shipping & Delivery 🚚",
                    items: [
                      FAQItem(
                        question: "How long does delivery take?",
                        answer: "Standard delivery takes 2-4 business days. Express delivery is available for Colombo and suburbs (same day).",
                      ),
                      FAQItem(
                        question: "What are the shipping costs?",
                        answer: "Good news! We offer 100% Free Shipping on all orders, island-wide! No minimum purchase required. 🐾🚚",
                      ),
                    ],
                  ),
                  const FAQSection(
                    title: "Orders & Returns 🔄",
                    items: [
                      FAQItem(
                        question: "Can I return an item?",
                        answer: "Yes, we have a 7-day return policy for unopened items. Perishable food items cannot be returned unless damaged.",
                      ),
                      FAQItem(
                        question: "How can I review a product?",
                        answer: "You can share your feedback by going to any product page or viewing your 'Review History' in your profile. We love hearing from our pet community! ⭐🐾",
                      ),
                    ],
                  ),
                  const FAQSection(
                    title: "Professional Pet Services 🏥✂️",
                    items: [
                      FAQItem(
                        question: "What is the difference between 'Services' and 'Care Tips'?",
                        answer: "The 'Services' section allows you to book professional appointments (like Grooming or Vet visits) performed by our experts. 'Care Tips' are free guides for you to look after your pet at home! 🐾",
                      ),
                      FAQItem(
                        question: "How do I book a grooming or vet appointment?",
                        answer: "Browse our 'Services' category, choose a service (e.g., Full Grooming), and select your preferred date/time on the booking screen. 📅",
                      ),
                      FAQItem(
                        question: "Can I cancel or reschedule my appointment?",
                        answer: "Yes! Please contact our team via the 'Contact Us' button at least 24 hours in advance if you need to change your professional service booking. 📞",
                      ),
                    ],
                  ),
                  const FAQSection(
                    title: "DIY Pet Care Tips 🐾💡",
                    items: [
                      FAQItem(
                        question: "How often should I groom my pet at home?",
                        answer: "For basic maintenance between professional visits, we recommend brushing your pet 2-3 times a week depending on their coat type. 🐈",
                      ),
                      FAQItem(
                        question: "What is the best food for puppies?",
                        answer: "Puppies need nutrition for growth! Check our 'Pet Care Tips' articles for detailed feeding guides based on breed and age. 🐕",
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

