import 'package:flutter/material.dart';
import 'package:karu/models/alert_item.dart';
import 'package:karu/screens/my_reported_cases/manage_case.dart';
import 'dart:io';

Widget buildCaseCard(
  AlertItem alert,
  bool isSmallScreen,
  BuildContext context,
) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ManageCasePage(caseItem: alert),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.file(File(alert.imageUrl), fit: BoxFit.cover),
                ),
              ),
              // Positioned(
              //   top: 12,
              //   left: 12,
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 12,
              //       vertical: 6,
              //     ),
              //     decoration: BoxDecoration(
              //       color: alert.type == AlertType.missing
              //           ? Colors.red.shade500
              //           : Colors.grey.shade700,
              //       borderRadius: BorderRadius.circular(6),
              //     ),
              //     child: Text(
              //       alert.type == AlertType.missing ? 'MISSING' : 'SILVER ALERT',
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 11,
              //         fontWeight: FontWeight.bold,
              //         letterSpacing: 0.5,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),

          // Details section
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${alert.name}, ${alert.age} yrs',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share_outlined,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      onPressed: () {
                        // Handle share
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Missing for ${alert.createdAt.minute} minutes',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  alert.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle report sighting
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         MissingPersonProfilePage(alert: alert),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 12 : 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Report Sighting',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 15 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.grey.shade700,
                        ),
                        onPressed: () {
                          // Handle QR code scan
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
