import 'dart:io';
import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';

class SharePosterDesign extends StatelessWidget {
  const SharePosterDesign({super.key, required this.alert});

  final AlertItem alert;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 600,
      color: Colors.blue,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            // Missing Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  'MISSING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),

            // Row with photo and Qr code
            Row(
              children: [
                // Photo placeholder
                Container(
                  height: 300,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.file(File(alert.imageUrl), fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                // QR Code Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.qr_code_2,
                        size: 60,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const Text(
                      'SCAN TO\nCONTACT FAMILY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Name and Age
            Center(
              child: Column(
                children: [
                  Text(
                    alert.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Age: ${alert.age} • Height: ${alert.height}cm",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            // Last seen
            Text(
              "Last seen at Post Central Park, Yde on ${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year} at ${alert.createdAt.hour}:${alert.createdAt.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
