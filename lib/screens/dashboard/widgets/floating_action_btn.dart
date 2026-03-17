import 'package:flutter/material.dart';

Widget buildFloatingActionButton(void Function() onTap) {
  return Container(
    width: 64,
    height: 64,
    decoration: BoxDecoration(
      color: Colors.red.shade600,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.red.shade600.withAlpha(40),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    ),
  );
}
