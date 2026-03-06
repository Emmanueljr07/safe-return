import 'package:flutter/material.dart';

class CaseActionButtons extends StatelessWidget {
  const CaseActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.edit,
          label: 'Edit Case Details',
          onTap: () {
            // Navigate to edit case details
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.download,
          label: 'Download Poster PDF',
          onTap: () {
            // Handle download
          },
        ),
      ],
    );
  }
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(20),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
