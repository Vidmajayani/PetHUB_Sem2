import 'package:flutter/material.dart';

class NotesField extends StatelessWidget {
  final TextEditingController notes;
  const NotesField({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Order Notes (Optional)",
          style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.grey[300] : Colors.black87),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: notes,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'Any special instructions?',
            hintStyle: TextStyle(fontSize: 14, color: isDark ? Colors.grey[600] : Colors.grey.shade400),
            prefixIcon: Icon(Icons.note, color: isDark ? Colors.grey[400] : Colors.grey[600]),
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
