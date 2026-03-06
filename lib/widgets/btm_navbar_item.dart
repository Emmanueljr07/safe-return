import 'package:flutter/material.dart';

Widget navItem({
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey.shade600,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
