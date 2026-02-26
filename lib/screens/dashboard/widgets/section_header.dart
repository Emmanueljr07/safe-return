import 'package:flutter/material.dart';

Widget buildSectionHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Active Alerts Nearby',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      TextButton(
        onPressed: () {
          // Handle see all
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: const Row(
          children: [
            Text(
              'See All',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    ],
  );
}
