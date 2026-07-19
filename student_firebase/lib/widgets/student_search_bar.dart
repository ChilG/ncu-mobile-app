import 'package:flutter/material.dart';

class StudentSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClearButton;

  const StudentSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.showClearButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search by student ID or name...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
          suffixIcon: showClearButton
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
