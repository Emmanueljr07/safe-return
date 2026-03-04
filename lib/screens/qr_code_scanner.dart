import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// QR Code Scanner Screen
class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool isScanning = true;
  String? scannedData;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              cameraController.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch, color: Colors.white),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (!isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;

              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  setState(() {
                    isScanning = false;
                    scannedData = barcode.rawValue;
                  });
                  _handleScannedData(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // Scanning overlay
          _buildScanningOverlay(),

          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Position the QR code within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay() {
    return CustomPaint(painter: ScannerOverlayPainter(), child: Container());
  }

  /// Handle the scanned QR code data
  void _handleScannedData(String data) {
    print('Scanned QR Code: $data');

    // Try to parse as JSON first
    try {
      final jsonData = jsonDecode(data);
      if (jsonData['type'] == 'missing_person') {
        _navigateToCase(jsonData['case_id'], jsonData);
        return;
      }
    } catch (e) {
      // Not JSON, might be a URL
    }

    // Check if it's a URL
    if (data.startsWith('http://') || data.startsWith('https://')) {
      // Extract case ID from URL
      final uri = Uri.parse(data);
      final segments = uri.pathSegments;

      if (segments.length >= 2 && segments[segments.length - 2] == 'case') {
        final caseId = segments.last;
        _navigateToCase(caseId, null);
        return;
      }
    }

    // Unknown format
    _showErrorDialog('Invalid QR Code', 'This QR code is not recognized.');
  }

  /// Navigate to case status page
  void _navigateToCase(String caseId, Map<String, dynamic>? caseData) {
    Navigator.pop(context);

    // Navigate to case status page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CaseStatusPage(caseId: caseId, caseData: caseData),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isScanning = true; // Resume scanning
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for scanning frame overlay
class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Draw semi-transparent overlay
    final backgroundPaint = Paint()..color = Colors.black.withOpacity(0.5);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Clear center area
    final clearPaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
        const Radius.circular(20),
      ),
      clearPaint,
    );

    // Draw corner brackets
    final borderPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final cornerLength = 30.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + cornerLength)
        ..lineTo(left, top)
        ..lineTo(left + cornerLength, top),
      borderPaint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize - cornerLength, top)
        ..lineTo(left + scanAreaSize, top)
        ..lineTo(left + scanAreaSize, top + cornerLength),
      borderPaint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(left, top + scanAreaSize - cornerLength)
        ..lineTo(left, top + scanAreaSize)
        ..lineTo(left + cornerLength, top + scanAreaSize),
      borderPaint,
    );

    // Bottom-right corner
    canvas.drawPath(
      Path()
        ..moveTo(left + scanAreaSize - cornerLength, top + scanAreaSize)
        ..lineTo(left + scanAreaSize, top + scanAreaSize)
        ..lineTo(left + scanAreaSize, top + scanAreaSize - cornerLength),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Placeholder Case Status Page
class CaseStatusPage extends StatelessWidget {
  final String caseId;
  final Map<String, dynamic>? caseData;

  const CaseStatusPage({Key? key, required this.caseId, this.caseData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Case #$caseId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'QR Code Scanned Successfully!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Case ID: $caseId',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            if (caseData != null) ...[
              const SizedBox(height: 16),
              Text('Name: ${caseData!['name']}'),
              Text('Age: ${caseData!['age']}'),
            ],
          ],
        ),
      ),
    );
  }
}
