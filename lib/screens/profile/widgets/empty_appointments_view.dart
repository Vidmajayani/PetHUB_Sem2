import 'package:flutter/material.dart';

class EmptyAppointmentsView extends StatelessWidget {
  const EmptyAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          const Text(
            "No appointments yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Book a professional consultation to see it here!",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
