import 'package:flutter/material.dart';
import 'package:karu/services/qr_code_service.dart';

class QRCodeSection extends StatelessWidget {
  final String caseId;

  const QRCodeSection({super.key, required this.caseId});

  @override
  Widget build(BuildContext context) {
    final qrService = QRCodeService();
    final qrData = qrService.generateCaseURL(caseId: caseId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        qrService.buildQRCodeWidget(data: qrData, size: 100),
        const SizedBox(height: 8),
        const Text(
          'Scan for Live Status',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Case #${caseId.substring(0, 6)}',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
