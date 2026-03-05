import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

/// Service class to handle QR code generation and scanning
class QRCodeService {
  /// Generate QR Code data for a missing person case
  ///
  /// This creates a JSON structure that can be encoded in QR
  String generateCaseQRData({
    required String caseId,
    required String name,
    required int age,
    String? baseUrl,
  }) {
    // Create a deep link or API endpoint URL
    final url = baseUrl ?? 'myreturnapp://items';
    final qrData = {
      'type': 'missing_person',
      'case_id': caseId,
      'name': name,
      'age': age,
      'url': '$url/$caseId',
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Convert to JSON string
    return jsonEncode(qrData);
  }

  /// Generate a simple URL-based QR code
  ///
  /// Most common approach - QR contains a URL
  String generateCaseURL({required String caseId, String? baseUrl}) {
    final url = baseUrl ?? 'myreturnapp://items';
    return '$url/$caseId';
  }

  /// Widget to display QR Code
  Widget buildQRCodeWidget({
    required String data,
    double size = 200,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      backgroundColor: backgroundColor ?? Colors.white,
      eyeStyle: QrEyeStyle(
        color: foregroundColor ?? Colors.black,
        eyeShape: QrEyeShape.square,
      ),
      gapless: true,
      errorStateBuilder: (context, error) {
        return Container(
          width: size,
          height: size,
          color: Colors.red.shade100,
          child: const Center(
            child: Text('QR Code Error', style: TextStyle(color: Colors.red)),
          ),
        );
      },
    );
  }
}
