import 'package:flutter/material.dart';

class NotesField extends StatelessWidget {
  final TextEditingController notes;
  const NotesField({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Notes (Optional)",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: notes,
          decoration: const InputDecoration(
            hintText: 'Any special instructions?',
            prefixIcon: Icon(Icons.note),
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
